import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifebridge/state/app_state.dart';
import 'package:lifebridge/services/ai_service.dart';
import 'package:lifebridge/screens/ai_assistant_119_128.dart';
import 'package:lifebridge/screens/profile_135_147.dart';

Widget _wrap(AppState s, Widget child) {
  return AppScope(
    state: s,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  setUp(() {
    // Isolated prefs for every test; AI key intentionally left empty.
    SharedPreferences.setMockInitialValues({});
  });

  group('AI settings state', () {
    test('fresh state uses OpenRouter base/model defaults, key empty until entered', () {
      final s = AppState();
      expect(s.effectiveAiBaseUrl, 'https://openrouter.ai/api/v1');
      expect(s.effectiveAiApiKey, isEmpty);
      expect(s.aiConfigured, isFalse);
    });

    test('asking without a key fails honestly before any network', () async {
      final s = AppState();
      await expectLater(
        s.askAi(task: 't', messages: const [AiChatMessage(role: 'user', content: 'hi')]),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('not configured'))),
      );
    });

    test('asking with a saved key reaches the endpoint', () async {
      final s = AppState();
      await s.saveAiSettings(baseUrl: 'https://example.com/v1', apiKey: 'sk-test', model: 'm');
      var calledUrl = '';
      final client = MockClient((req) async {
        calledUrl = req.url.toString();
        return http.Response('{"choices":[{"message":{"content":"ok"}}]}', 200);
      });
      final out = await s.askAi(task: 't', messages: const [AiChatMessage(role: 'user', content: 'hi')], client: client);
      expect(out, 'ok');
      expect(calledUrl, startsWith('https://example.com/v1/chat/completions'));
    });

    test('saveAiSettings flips configured and persists', () async {
      final s = AppState();
      await s.saveAiSettings(baseUrl: 'https://example.com/v1', apiKey: 'sk-live-test', model: 'test-model');
      expect(s.aiConfigured, isTrue);
      expect(s.aiModel, 'test-model');

      // A fresh state object loads the persisted values.
      final s2 = AppState();
      await s2.loadAiSettings();
      expect(s2.aiApiKey, 'sk-live-test');
      expect(s2.aiModel, 'test-model');
      expect(s2.aiBaseUrl, 'https://example.com/v1');
    });

    test('case context reflects app data', () {
      final s = AppState();
      final ctx = s.aiCaseContext();
      expect(ctx, contains(s.user.name));
      expect(ctx, contains(s.mainCase.title));
      expect(ctx, contains('₹'));
    });

    test('askAiJson surfaces endpoint failures honestly', () async {
      final s = AppState();
      await s.saveAiSettings(baseUrl: 'https://example.com/v1', apiKey: 'sk-test', model: 'm');
      final client = MockClient((_) async => http.Response('not json at all', 200));
      await expectLater(
        s.askAiJson(task: 't', userContent: 'u', client: client),
        throwsA(isA<AiException>().having((e) => e.message, 'message', contains('could not understand'))),
      );
    });

    test('askAi trims long history to a sliding window', () async {
      final s = AppState();
      await s.saveAiSettings(baseUrl: 'https://example.com/v1', apiKey: 'sk-test', model: 'm');
      List<dynamic>? sent;
      final client = MockClient((req) async {
        final body = jsonDecode(req.body) as Map<String, dynamic>;
        sent = body['messages'] as List<dynamic>;
        return http.Response('{"choices":[{"message":{"content":"ok"}}]}', 200);
      });
      final history = [
        for (var i = 0; i < 20; i++) AiChatMessage(role: i.isEven ? 'user' : 'assistant', content: 'm$i'),
      ];
      final out = await s.askAi(task: 't', messages: history, client: client);
      expect(out, 'ok');
      expect(sent!.length, 11); // system prompt + last 10
      expect((sent!.first as Map)['role'], 'system');
      expect((sent!.last as Map)['content'], 'm19');
    });

    test('system prompt scopes answers to the app', () {
      final s = AppState();
      final prompt = s.aiSystemPrompt('test task');
      expect(prompt, contains('test task'));
      expect(prompt, contains('only answer questions related to this app'));
      expect(prompt, contains(s.user.name));
    });
  });

  group('AI settings screen', () {
    testWidgets('renders fields and saves', (tester) async {
      final s = AppState();
      await tester.pumpWidget(_wrap(s, const AiSettingsScreen()));
      await tester.pump();
      expect(find.text('AI assistant setup'), findsOneWidget);
      expect(find.text('Base URL'), findsOneWidget);
      expect(find.text('API key'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'https://example.com/v1');
      await tester.enterText(find.byType(TextField).at(1), 'test-model');
      await tester.enterText(find.byType(TextField).at(2), 'sk-widget-test');
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save AI settings').first, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(s.aiConfigured, isTrue);
      expect(s.aiModel, 'test-model');
    });
  });

  group('AI settings model fetch (unreachable server)', () {
    testWidgets('fetch shows error, no fake list', (tester) async {
      final s = AppState();
      await tester.pumpWidget(_wrap(s, const AiSettingsScreen()));
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(0), 'http://127.0.0.1:9');
      await tester.enterText(find.byType(TextField).at(2), 'sk-test-unreachable');
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fetch available models').first, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(find.text('Could not fetch models'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('AI chat (unreachable backend)', () {
    testWidgets('sending shows the honest connection error, no fake answer', (tester) async {
      final s = AppState();
      await s.saveAiSettings(baseUrl: 'notaurl', apiKey: 'sk-test-unreachable', model: 'm');
      await tester.pumpWidget(_wrap(s, const AIChatScreen()));
      await tester.pump();
      expect(find.textContaining('LifeBridge AI'), findsWidgets);

      await tester.enterText(find.byType(TextField), 'What should I do next?');
      await tester.tap(find.text('Send'));
      await tester.pump(); // user bubble + spinner
      expect(find.text('What should I do next?'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5)); // failed request resolves
      await tester.pump();
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.textContaining('looks invalid'), findsOneWidget);
    });
  });
}
