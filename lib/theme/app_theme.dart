import 'package:flutter/material.dart';

class SetansTheme {
  SetansTheme._();

  static const _primary = Color(0xFF1565C0);
  static const _primaryLight = Color(0xFF42A5F5);
  static const _primaryDark = Color(0xFF0D47A1);
  static const _surface = Color(0xFFE3F2FD);
  static const _saturdayBg = Color(0xFFC5CAE9);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      onPrimary: Colors.white,
      surface: _surface,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: _surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFBBDEFB),
        thickness: 1,
      ),
    );
  }

  static Color get primary => _primary;
  static Color get primaryLight => _primaryLight;
  static Color get primaryDark => _primaryDark;
  static Color get surface => _surface;
  static Color get saturdayBg => _saturdayBg;
  static Color get present => const Color(0xFF43A047);
  static Color get presentBg => const Color(0xFFC8E6C9);
  static Color get absent => const Color(0xFFE53935);
  static Color get absentBg => const Color(0xFFFFCDD2);
  static Color get onPrimary => Colors.white;
  static Color get onSurface => const Color(0xFF212121);
}
