import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lifebridge/services/ai_service.dart';

void main() {
  group('AiService.parseJsonObject', () {
    test('parses plain JSON object', () {
      final m = AiService.parseJsonObject('{"summary":"ok","matchedPrograms":3}');
      expect(m, isNotNull);
      expect(m!['summary'], 'ok');
      expect(m['matchedPrograms'], 3);
    });

    test('strips markdown fences', () {
      final m = AiService.parseJsonObject('```json\n{"a":1}\n```');
      expect(m, isNotNull);
      expect(m!['a'], 1);
    });

    test('extracts object from surrounding prose', () {
      final m = AiService.parseJsonObject('Here you go {"x":"y"} hope it helps');
      expect(m, isNotNull);
      expect(m!['x'], 'y');
    });

    test('returns null for non-JSON', () {
      expect(AiService.parseJsonObject('just some words'), isNull);
      expect(AiService.parseJsonObject(''), isNull);
      expect(AiService.parseJsonObject('[1,2,3]'), isNull);
    });
  });

  group('AiService.chat validation (no network)', () {
    test('throws when API key is empty', () async {
      await expectLater(
        AiService.chat(
          baseUrl: 'https://api.openai.com/v1',
          apiKey: '  ',
          model: 'gpt-4o-mini',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
        ),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('not configured'))),
      );
    });

    test('throws when base URL is empty', () async {
      await expectLater(
        AiService.chat(
          baseUrl: '  ',
          apiKey: 'sk-test',
          model: 'gpt-4o-mini',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
        ),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('base URL'))),
      );
    });

    test('throws when model is empty', () async {
      await expectLater(
        AiService.chat(
          baseUrl: 'https://api.openai.com/v1',
          apiKey: 'sk-test',
          model: ' ',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
        ),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('model'))),
      );
    });

    test('throws when base URL is malformed', () async {
      await expectLater(
        AiService.chat(
          baseUrl: 'not a url at all :::',
          apiKey: 'sk-test',
          model: 'gpt-4o-mini',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
        ),
        throwsA(isA<AiException>()),
      );
    });
  });

  group('AiService request workflow (mocked HTTP)', () {
    test('success returns content and sends model + messages', () async {
      Map<String, dynamic>? sent;
      final client = MockClient((req) async {
        sent = (await _readJson(req)) as Map<String, dynamic>;
        return http.Response('{"choices":[{"message":{"content":"hello there"}}]}', 200);
      });
      final out = await AiService.chat(
        baseUrl: 'https://example.com/v1',
        apiKey: 'sk-test',
        model: 'test-model',
        messages: const [AiChatMessage(role: 'user', content: 'hi')],
        client: client,
      );
      expect(out, 'hello there');
      expect(sent!['model'], 'test-model');
      expect((sent!['messages'] as List).length, 1);
    });

    test('jsonMode adds response_format flag', () async {
      Map<String, dynamic>? sent;
      final client = MockClient((req) async {
        sent = (await _readJson(req)) as Map<String, dynamic>;
        return http.Response('{"choices":[{"message":{"content":"{}"}}]}', 200);
      });
      await AiService.chat(
        baseUrl: 'https://example.com/v1',
        apiKey: 'sk-test',
        model: 'm',
        messages: const [AiChatMessage(role: 'user', content: 'hi')],
        jsonMode: true,
        client: client,
      );
      expect((sent!['response_format'] as Map)['type'], 'json_object');
    });

    test('429 maps to rate-limit guidance', () async {
      final client = MockClient((_) async => http.Response('{"error":{"message":"slow down"}}', 429));
      await expectLater(
        AiService.chat(
          baseUrl: 'https://example.com/v1',
          apiKey: 'sk-test',
          model: 'm',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
          client: client,
        ),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('rate-limited'))),
      );
    });

    test('400 context overflow maps to new-chat guidance', () async {
      final client = MockClient((_) async => http.Response(
            '{"error":{"message":"This model\'s maximum context length is 4096 tokens"}}',
            400,
          ));
      await expectLater(
        AiService.chat(
          baseUrl: 'https://example.com/v1',
          apiKey: 'sk-test',
          model: 'm',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
          client: client,
        ),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('too long'))),
      );
    });

    test('401 maps to key guidance without leaking the key', () async {
      final client = MockClient((_) async => http.Response('{"error":{"message":"bad key"}}', 401));
      try {
        await AiService.chat(
          baseUrl: 'https://example.com/v1',
          apiKey: 'sk-super-secret',
          model: 'm',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
          client: client,
        );
        fail('expected AiException');
      } on AiException catch (e) {
        expect(e.message, contains('401'));
        expect(e.message, isNot(contains('sk-super-secret')));
      }
    });

    test('fetchModels parses and sorts ids', () async {
      final client = MockClient((req) async {
        expect(req.url.path, endsWith('/models'));
        return http.Response('{"data":[{"id":"b-model"},{"id":"a-model"},{"id":""}]}', 200);
      });
      final ids = await AiService.fetchModels(baseUrl: 'https://example.com/v1', apiKey: 'sk-test', client: client);
      expect(ids, ['a-model', 'b-model']);
    });

    test('accepts content-block list replies', () async {
      final client = MockClient((_) async => http.Response(
            '{"choices":[{"message":{"content":[{"type":"text","text":"hel"},{"type":"text","text":"lo"}]}}]}',
            200,
          ));
      final out = await AiService.chat(
        baseUrl: 'https://example.com/v1',
        apiKey: 'sk-test',
        model: 'm',
        messages: const [AiChatMessage(role: 'user', content: 'hi')],
        client: client,
      );
      expect(out, 'hello');
    });

    test('falls back to reasoning content when content is empty', () async {
      final client = MockClient((_) async => http.Response(
            '{"choices":[{"message":{"content":"","reasoning_content":"thinking out loud"}}]}',
            200,
          ));
      final out = await AiService.chat(
        baseUrl: 'https://example.com/v1',
        apiKey: 'sk-test',
        model: 'm',
        messages: const [AiChatMessage(role: 'user', content: 'hi')],
        client: client,
      );
      expect(out, 'thinking out loud');
    });

    test('accepts legacy .text replies', () async {
      final client = MockClient((_) async => http.Response('{"choices":[{"text":"legacy answer"}]}', 200));
      final out = await AiService.chat(
        baseUrl: 'https://example.com/v1',
        apiKey: 'sk-test',
        model: 'm',
        messages: const [AiChatMessage(role: 'user', content: 'hi')],
        client: client,
      );
      expect(out, 'legacy answer');
    });

    test('200 error envelope surfaces the server reason', () async {
      final client = MockClient((_) async => http.Response('{"error":{"message":"provider overloaded, retry shortly"}}', 200));
      await expectLater(
        AiService.chat(
          baseUrl: 'https://example.com/v1',
          apiKey: 'sk-test',
          model: 'm',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
          client: client,
        ),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('overloaded'))),
      );
    });

    test('empty reply maps to empty-reply guidance', () async {
      final client = MockClient((_) async => http.Response('{"choices":[{"message":{"content":"   "}}]}', 200));
      await expectLater(
        AiService.chat(
          baseUrl: 'https://example.com/v1',
          apiKey: 'sk-test',
          model: 'm',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
          client: client,
        ),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('empty reply'))),
      );
    });

    test('unparseable body includes a server preview', () async {
      final client = MockClient((_) async => http.Response('<html>gateway blew up</html>', 200));
      await expectLater(
        AiService.chat(
          baseUrl: 'https://example.com/v1',
          apiKey: 'sk-test',
          model: 'm',
          messages: const [AiChatMessage(role: 'user', content: 'hi')],
          client: client,
        ),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('gateway blew up'))),
      );
    });
  });

  group('AiService.fetchModels validation (no network)', () {
    test('throws when key or base URL missing', () async {
      await expectLater(
        AiService.fetchModels(baseUrl: '', apiKey: ''),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('base URL'))),
      );
      await expectLater(
        AiService.fetchModels(baseUrl: 'https://api.openai.com/v1', apiKey: '   '),
        throwsA(isA<AiException>()),
      );
    });

    test('throws when base URL is malformed', () async {
      await expectLater(
        AiService.fetchModels(baseUrl: 'not a url :::', apiKey: 'sk-test'),
        throwsA(isA<AiException>()),
      );
    });
  });
}

Future<Object?> _readJson(http.BaseRequest req) async {
  if (req is http.Request) {
    return req.body.isEmpty ? null : jsonDecode(req.body);
  }
  final bytes = await req.finalize().toBytes();
  return jsonDecode(String.fromCharCodes(bytes));
}
