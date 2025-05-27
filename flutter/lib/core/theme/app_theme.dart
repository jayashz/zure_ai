import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF10A37F); // ChatGPT green
  static const Color backgroundColor = Color(0xFF343541); // Main background
  static const Color secondaryBackgroundColor = Color(
    0xFF444654,
  ); // AI message background
  static const Color inputBackgroundColor = Color(
    0xFF40414F,
  ); // Input field background
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color textLightColor = Color(0xFFABABAD);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: secondaryBackgroundColor,
        surfaceDim: backgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: textColor, fontSize: 14, height: 1.5),
        titleMedium: TextStyle(
          color: textLightColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackgroundColor,
        hintStyle: const TextStyle(color: textLightColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      iconTheme: const IconThemeData(color: textColor, size: 24),
    );
  }
}
