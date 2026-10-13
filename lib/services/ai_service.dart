import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// One message in an OpenAI-compatible chat-completions conversation.
class AiChatMessage {
  final String role; // 'system' | 'user' | 'assistant'
  final String content;
  const AiChatMessage({required this.role, required this.content});

  Map<String, String> toJson() => {'role': role, 'content': content};
}

/// User-facing AI failure. [message] never contains secrets.
class AiException implements Exception {
  final String message;
  const AiException(this.message);
  @override
  String toString() => 'AiException: $message';
}

/// Minimal OpenAI-compatible chat client.
///
/// Works with OpenAI, OpenRouter, Together, local gateways (Ollama via an
/// OpenAI-compat proxy), or any server implementing POST /chat/completions.
/// The API key is only ever sent as an Authorization header — it is never
/// logged, never echoed in errors, and never rendered in UI.
class AiService {
  static Future<String> chat({
    required String baseUrl,
    required String apiKey,
    required String model,
    required List<AiChatMessage> messages,
    double temperature = 0.4,
    int maxTokens = 900,
    Duration timeout = const Duration(seconds: 60),
    bool jsonMode = false,
    http.Client? client,
  }) async {
    final base = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final key = apiKey.trim();
    final name = model.trim();
    if (base.isEmpty) {
      throw const AiException('AI base URL is empty. Set it in Profile > Settings > AI assistant.');
    }
    if (key.isEmpty) {
      throw const AiException('AI is not configured yet. Add your API key in Profile > Settings > AI assistant.');
    }
    if (name.isEmpty) {
      throw const AiException('No AI model selected. Choose one in Profile > Settings > AI assistant.');
    }
    if (messages.isEmpty) {
      throw const AiException('Nothing to send to the AI. Type a message first.');
    }

    late final Uri uri;
    try {
      uri = Uri.parse('$base/chat/completions');
      if (!uri.hasScheme || !uri.hasAuthority) throw const FormatException();
    } catch (_) {
      throw const AiException('The AI base URL looks invalid. Check it in Profile > Settings > AI assistant.');
    }

    http.Response res;
    final httpClient = client ?? http.Client();
    Map<String, dynamic> body(bool useJson) => {
          'model': name,
          'messages': [for (final m in messages) m.toJson()],
          'temperature': temperature,
          'max_tokens': maxTokens,
          if (useJson) 'response_format': {'type': 'json_object'},
        };
    Future<http.Response> post(bool useJson) {
      return httpClient
          .post(
            uri,
            headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $key'},
            body: jsonEncode(body(useJson)),
          )
          .timeout(timeout);
    }

    try {
      res = await post(jsonMode);
    } on SocketException {
      throw const AiException('No internet connection. Check your network and try again.');
    } on TimeoutException {
      throw const AiException('The AI request timed out. Try again in a moment.');
    } on http.ClientException {
      throw const AiException('Could not reach the AI server. Check the base URL and try again.');
    } catch (_) {
      throw const AiException('Could not reach the AI server. Check the base URL and try again.');
    } finally {
      if (client == null) httpClient.close();
    }

    // Some providers reject the standard JSON-mode flag: retry once without it.
    if (jsonMode && res.statusCode == 400 && res.body.contains('response_format')) {
      final retryClient = client ?? http.Client();
      try {
        res = await retryClient.post(
          uri,
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $key'},
          body: jsonEncode(body(false)),
        ).timeout(timeout);
      } on SocketException {
        throw const AiException('No internet connection. Check your network and try again.');
      } on TimeoutException {
        throw const AiException('The AI request timed out. Try again in a moment.');
      } catch (_) {
        throw const AiException('Could not reach the AI server. Check the base URL and try again.');
      } finally {
        if (client == null) retryClient.close();
      }
    }

    switch (res.statusCode) {
      case 200:
        break;
      case 400: {
        final detail = _serverMessage(res.body);
        final low = '${res.body} $detail'.toLowerCase();
        if (low.contains('context') || low.contains('maximum') || low.contains('too many tokens') || low.contains('too large') || low.contains('token limit')) {
          throw AiException('This conversation grew too long for the selected model. Start a new chat and ask again. ($detail)');
        }
        throw AiException('The AI request was rejected (400): $detail');
      }
      case 401:
        throw const AiException('The API key was rejected (401). Check it in Profile > Settings > AI assistant.');
      case 403:
        throw const AiException('The API key lacks access (403). Check your plan or key permissions.');
      case 404:
        throw AiException('The AI endpoint or model was not found (404). Check the base URL and model name. ${_serverMessage(res.body)}');
      case 429:
        throw const AiException('The AI is rate-limited right now (429). Free-tier keys allow only a few requests per minute — wait a bit and try again.');
      default:
        if (res.statusCode >= 500) {
          throw AiException('The AI server had a problem (${res.statusCode}). Try again shortly. ${_serverMessage(res.body)}');
        }
        throw AiException('The AI request failed (${res.statusCode}). ${_serverMessage(res.body)}');
    }

    // Some gateways answer HTTP 200 with an error envelope instead of choices.
    // Surface the real reason rather than a generic parse failure.
    Map<String, dynamic>? root;
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) root = decoded;
    } catch (_) {}
    if (root != null) {
      final choices = root['choices'];
      final hasChoices = choices is List && choices.isNotEmpty;
      if (!hasChoices) {
        final err = root['error'];
        final msg = err is Map
            ? (err['message'] is String ? (err['message'] as String).trim() : '')
            : (err is String ? err.trim() : '');
        if (msg.isNotEmpty) {
          final clean = msg.replaceAll(RegExp(r'\s+'), ' ');
          throw AiException('The AI server reported a problem: ${clean.length > 220 ? '${clean.substring(0, 220)}…' : clean}');
        }
      }
    }

    try {
      final text = _extractText(root ?? jsonDecode(res.body));
      if (text.trim().isEmpty) {
        throw const AiException('The AI returned an empty reply. Try again — rephrasing sometimes helps.');
      }
      return text.trim();
    } on AiException {
      rethrow;
    } catch (_) {
      throw AiException('The AI returned a response this app could not understand. Try again. (Server said: ${_preview(res.body)})');
    }
  }

  /// Reads reply text from the shapes real providers return:
  /// standard message.content (string or content-block list), reasoning-model
  /// fallbacks (reasoning_content/reasoning), legacy .text, and common
  /// gateway envelopes. Returns '' when nothing usable is present.
  static String _extractText(dynamic data) {
    if (data is! Map) return '';
    String blockText(dynamic content) {
      if (content is String) return content;
      if (content is List) {
        return content
            .whereType<Map>()
            .map((b) => b['text'])
            .whereType<String>()
            .join('');
      }
      return '';
    }

    final choices = data['choices'];
    if (choices is List && choices.isNotEmpty) {
      final first = choices.first;
      if (first is Map) {
        final message = first['message'];
        if (message is Map) {
          final content = blockText(message['content']);
          if (content.trim().isNotEmpty) return content;
          for (final key in ['reasoning_content', 'reasoning']) {
            final r = message[key];
            if (r is String && r.trim().isNotEmpty) return r;
          }
        }
        final text = first['text'];
        if (text is String && text.trim().isNotEmpty) return text;
      }
    }
    // Non-standard envelopes some gateways use.
    for (final key in ['output_text', 'response', 'answer', 'generated_text']) {
      final v = data[key];
      if (v is String && v.trim().isNotEmpty) return v;
    }
    final message = data['message'];
    if (message is Map) {
      final content = blockText(message['content']);
      if (content.trim().isNotEmpty) return content;
    }
    return '';
  }

  static String _preview(String body) {
    final clean = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.isEmpty) return 'empty response';
    return '"${clean.length > 160 ? '${clean.substring(0, 160)}…' : clean}"';
  }

  /// Best-effort extraction of a JSON object from model output
  /// (models often wrap JSON in ```json fences or prose).
  static Map<String, dynamic>? parseJsonObject(String text) {
    try {
      var t = text.trim();
    // Strip markdown fences.
      if (t.startsWith('```')) {
        final firstNl = t.indexOf('\n');
        t = firstNl >= 0 ? t.substring(firstNl + 1) : t.substring(3);
        final fence = t.lastIndexOf('```');
        if (fence >= 0) t = t.substring(0, fence);
      }
      final start = t.indexOf('{');
      final end = t.lastIndexOf('}');
      if (start < 0 || end <= start) return null;
      final decoded = jsonDecode(t.substring(start, end + 1));
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Lists model IDs advertised by an OpenAI-compatible provider
  /// (GET {baseUrl}/models). Used by the settings screen so users can pick
  /// from real provider models instead of typing a name. Throws [AiException]
  /// with a user-facing message on any failure.
  static Future<List<String>> fetchModels({
    required String baseUrl,
    required String apiKey,
    Duration timeout = const Duration(seconds: 30),
    http.Client? client,
  }) async {
    final base = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final key = apiKey.trim();
    if (base.isEmpty || key.isEmpty) {
      throw const AiException('Enter the base URL and API key first, then fetch models.');
    }

    late final Uri uri;
    try {
      uri = Uri.parse('$base/models');
      if (!uri.hasScheme || !uri.hasAuthority) throw const FormatException();
    } catch (_) {
      throw const AiException('The AI base URL looks invalid. Check it and try again.');
    }

    http.Response res;
    final httpClient = client ?? http.Client();
    try {
      res = await httpClient.get(uri, headers: {'Authorization': 'Bearer $key'}).timeout(timeout);
    } on SocketException {
      throw const AiException('No internet connection. Check your network and try again.');
    } on TimeoutException {
      throw const AiException('The model list request timed out. Try again in a moment.');
    } on http.ClientException {
      throw const AiException('Could not reach the AI server. Check the base URL and try again.');
    } catch (_) {
      throw const AiException('Could not reach the AI server. Check the base URL and try again.');
    } finally {
      if (client == null) httpClient.close();
    }

    switch (res.statusCode) {
      case 200:
        break;
      case 401:
        throw const AiException('The API key was rejected (401). Check it and try again.');
      case 403:
        throw const AiException('The API key lacks access (403). Check your plan or key permissions.');
      case 404:
        throw const AiException('This provider does not list models at /models (404). Type the model name manually instead.');
      case 429:
        throw const AiException('The AI is rate-limited right now (429). Free-tier keys allow only a few requests per minute — wait a bit and try again.');
      default:
        throw AiException('Fetching models failed (${res.statusCode}). ${_serverMessage(res.body)}');
    }

    try {
      final data = jsonDecode(res.body);
      final list = data is Map ? data['data'] : null;
      if (list is! List) throw const FormatException();
      final ids = <String>{
        for (final e in list)
          if (e is Map && (e['id'] is String) && (e['id'] as String).trim().isNotEmpty) (e['id'] as String).trim(),
      }.toList()
        ..sort();
      if (ids.isEmpty) throw const FormatException();
      return ids;
    } catch (e) {
      if (e is AiException) rethrow;
      throw const AiException('The provider returned a model list this app could not understand. Type the model name manually instead.');
    }
  }

  static String _serverMessage(String body) {
    try {
      final data = jsonDecode(body);
      final err = data is Map ? data['error'] : null;
      final msg = err is Map ? err['message'] : (err is String ? err : data['message']);
      if (msg is String && msg.trim().isNotEmpty) {
        final clean = msg.trim().replaceAll(RegExp(r'\s+'), ' ');
        return clean.length > 220 ? '${clean.substring(0, 220)}…' : clean;
      }
    } catch (_) {}
    return 'No details provided by the server.';
  }
}
