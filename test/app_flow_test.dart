import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifebridge/main.dart';
import 'package:lifebridge/router.dart';
import 'package:lifebridge/state/app_state.dart';
import 'package:lifebridge/widgets/components.dart';
import 'package:lifebridge/screens/ai_analysis_49_54.dart';
import 'package:lifebridge/screens/applications_76_99.dart';
import 'package:lifebridge/screens/documents_65_75.dart';
import 'package:lifebridge/screens/followups_100_118.dart';

Widget _wrap(AppState s, Widget child) {
  return AppScope(state: s, child: MaterialApp(home: Scaffold(body: child)));
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('cold start (unconfigured AI)', () {
    testWidgets('splash -> auth -> home renders with no exceptions', (tester) async {
      await tester.pumpWidget(const LifeBridgeApp());
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('LifeBridge'), findsOneWidget);

      // Let the ~1.5s splash timer finish.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back.'), findsOneWidget);

      // Log in straight to the dashboard.
      await tester.tap(find.widgetWithText(LbButton, 'Log in'));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('AI screens with unconfigured backend (no network)', () {
    testWidgets('analysis shows honest error with retry', (tester) async {
      await tester.pumpWidget(_wrap(AppState(), const AIAnalysisScreen()));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text('Analysis hit a snag.'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('response renders a provided answer without network', (tester) async {
      final s = AppState();
      await tester.pumpWidget(AppScope(
        state: s,
        child: MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: Builder(builder: (context) {
            Future.microtask(() => Navigator.pushNamed(
                  context,
                  '/ai/response',
                  arguments: const {'question': 'Why this program?', 'answer': 'Because it fits.'},
                ));
            return const SizedBox();
          }),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Why this program?'), findsOneWidget);
      expect(find.text('Because it fits.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('application draft shows honest error with retry', (tester) async {
      await tester.pumpWidget(_wrap(AppState(), const AIDraftScreen()));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text('Draft is ready.'), findsOneWidget);
      expect(find.textContaining('not configured'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('follow-up draft shows honest error with retry', (tester) async {
      await tester.pumpWidget(_wrap(AppState(), const AIFollowUpDraftScreen()));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.textContaining('not configured'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('extraction shows honest error with retry', (tester) async {
      await tester.pumpWidget(_wrap(AppState(), const AIDocumentExtractionScreen()));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text('Reading your document…'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
