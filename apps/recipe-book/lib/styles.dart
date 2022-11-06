import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: const Color(0xFFFDFFFC),
    scaffoldBackgroundColor: const Color(0xFFFDFFFC),
  );
}

const lightThemeTextColor = Color(0xFF0D0A0B);
const darkThemeTextColor = Color(0xFFFDFFFC);
const primaryColor = Color(0xFF1A936F);
const secondaryColor = Color(0xFF009FFD);
const tertiaryColor = Color(0xFFE26D5A);
