import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: darkThemeTextColor,
    scaffoldBackgroundColor: darkThemeTextColor,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: lightThemeTextColor,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: primaryColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      prefixIconColor: primaryColor,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
  );
}

const lightThemeTextColor = Color(0xFF0D0A0B);
const darkThemeTextColor = Color(0xFFFDFFFC);
const primaryColor = Color(0xFF1A936F);
const secondaryColor = Color(0xFF009FFD);
const tertiaryColor = Color(0xFFE26D5A);