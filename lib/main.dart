import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/theme.dart';
import 'state/app_state.dart';
import 'router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const LifeBridgeApp());
}

class LifeBridgeApp extends StatefulWidget {
  const LifeBridgeApp({super.key});
  @override
  State<LifeBridgeApp> createState() => _LifeBridgeAppState();
}

class _LifeBridgeAppState extends State<LifeBridgeApp> {
  final AppState _state = AppState();

  @override
  void initState() {
    super.initState();
    _state.loadAiSettings();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'LifeBridge',
        debugShowCheckedModeBanner: false,
        theme: buildLbTheme(),
        initialRoute: '/',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
