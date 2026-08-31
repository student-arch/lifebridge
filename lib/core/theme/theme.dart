import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LbColors {
  static const bg = Color(0xFFF1F1F1);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF7F7F7);
  static const fg = Color(0xFF000000);
  static const fg2 = Color(0xFF2B2B2B);
  static const muted = Color(0xFF757575);
  static const meta = Color(0xFF5A85D9);
  static const border = Color(0xFFE7E7E7);
  static const borderSoft = Color(0xFFEFEFEF);
  static const accent = Color(0xFF5A85D9);
  static const accentOn = Color(0xFFFFFFFF);
  static const accent2 = Color(0xFF7FA0E4);
  static const success = Color(0xFF3E9B6B);
  static const warn = Color(0xFFC98A2D);
  static const danger = Color(0xFFC64545);
  static const warnBg = Color(0xFFFBF3E4);
  static const dangerBg = Color(0xFFFAECEC);
  static const successBg = Color(0xFFE9F4EE);
  static const infoBg = Color(0xFFE9F0FA);
  static const accentSoft = Color(0x1F5A85D9);
  static const pillSuccessFg = Color(0xFF2E7D54);
  static const pillWarnFg = Color(0xFF8F5F1D);
  static const pillDangerFg = Color(0xFFA33A3A);
  static const pillInfoFg = Color(0xFF3D6CB4);
  static const emerald = Color(0xFF1D7A3D);
  static const cardWarnBorder = Color(0xFFCFDEF0);
}

class LbRadius {
  static const card = 28.0;
  static const hero = 32.0;
  static const field = 16.0;
  static const pill = 999.0;
  static const circle = 999.0;
  static const small = 8.0;
  static const medium = 14.0;
  static const large = 20.0;
}

class LbSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const section = 32.0;
}

class LbTypography {
  static const display = 'Lufga';
  static const body = 'Lufga';
}

ThemeData buildLbTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: LbColors.bg,
    canvasColor: LbColors.bg,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    colorScheme: const ColorScheme.light(
      primary: LbColors.accent,
      secondary: LbColors.fg,
      surface: LbColors.surface,
      error: LbColors.danger,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 15, color: LbColors.fg, height: 1.55),
      bodyMedium: TextStyle(fontSize: 15, color: LbColors.fg, height: 1.55),
      bodySmall: TextStyle(fontSize: 12, color: LbColors.muted),
      labelLarge: TextStyle(fontSize: 15, color: LbColors.fg, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 22, color: LbColors.fg, fontWeight: FontWeight.w600, letterSpacing: -0.4, height: 1.2),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
  );
}
