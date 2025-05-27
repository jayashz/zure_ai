import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color.fromRGBO(24, 119, 242, 1),
    scaffoldBackgroundColor: Colors.white,
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStatePropertyAll(
        Color.fromRGBO(24, 119, 242, 1),
      ),
    ),
    textTheme: GoogleFonts.rubikTextTheme(const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
          fontSize: 20, color: Color(0xFF4E4B66), letterSpacing: 0.12),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
      labelMedium: TextStyle(fontSize: 16, color: Color(0xFF667080)),
      labelSmall: TextStyle(fontSize: 14, color: Color(0xFF4E4B66)),
      headlineMedium: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.12,
      ),
      headlineSmall: TextStyle(
          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(24, 119, 242, 1),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color.fromRGBO(24, 119, 242, 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 24,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromRGBO(24, 119, 242, 1),
    scaffoldBackgroundColor: Colors.black,
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(Color.fromRGBO(24, 119, 242, 1)),
    ),
    textTheme: GoogleFonts.rubikTextTheme(const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE4E6EB),
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
      labelMedium: TextStyle(fontSize: 16, color: Color(0xFF667080)),
      labelSmall: TextStyle(fontSize: 14, color: Color(0xFFB0B3B8)),
      headlineMedium: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.12,
      ),
      headlineSmall: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(24, 119, 242, 1),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color.fromRGBO(24, 119, 242, 1),
        textStyle: const TextStyle(letterSpacing: 0.12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(fillColor: Color(0xFF3A3B3C)),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}
