import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: const Color(0xFFECECEC),
    scaffoldBackgroundColor: const Color(0xFFFBFFFE),
  );
}

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    backgroundColor: const Color(0xFF181F25),
    scaffoldBackgroundColor: const Color(0xFF101418),
  );
}

const Color primaryTextColor = Color(0xFF1446A0);
const Color secondaryTextColor = Color(0xFF5A7D7C);

const Color lightTextColor = Color(0xFF0A0A0A);
const Color lightTextColor2 = Color(0xFF585858);

const Color darkTextColor = Color(0xFFFBFFFE);
const Color darkTextColor2 = Color(0xFF9B9B9B);
