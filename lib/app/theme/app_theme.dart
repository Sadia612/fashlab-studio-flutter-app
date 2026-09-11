import 'package:flutter/material.dart';

class AppTheme {
  // Website Exact Color Palette
  static const Color primary = Color(0xFF6B2233);
  static const Color primaryDark = Color(0xFF47131F);
  static const Color primaryLight = Color(0xFF8D4352);
  static const Color primaryTint = Color(0xFFF6EEF0);

  static const Color gold = Color(0xFFB18A54);
  static const Color goldLight = Color(0xFFD8B98A);
  static const Color goldTint = Color(0xFFFAF5EC);

  static const Color ink = Color(0xFF1A1416);
  static const Color text = Color(0xFF2A2224);
  static const Color textLight = Color(0xFF6F6669);
  static const Color textMuted = Color(0xFF948B8E);

  // Text aliases
  static const Color textPrimary = Color(0xFF1A1416);
  static const Color textSecondary = Color(0xFF6F6669);

  // Background & Surface aliases
  static const Color cream = Color(0xFFFAF7F3);
  static const Color creamDark = Color(0xFFF0E9E0);
  static const Color background = Color(0xFFFAF7F3);
  static const Color surface = Colors.white;

  static const Color border = Color(0xFFE8E0D8);
  static const Color borderStrong = Color(0xFFD8CEC3);

  static const Color success = Color(0xFF2F7A51);
  static const Color whatsapp = Color(0xFF25D366);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: gold,
        surface: cream,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: ink),
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: gold, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: gold,
        selectionColor: goldLight,
        selectionHandleColor: gold,
      ),
    );
  }
}