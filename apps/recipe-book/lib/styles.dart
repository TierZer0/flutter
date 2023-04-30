import 'package:flutter/material.dart';

const lightThemeTextColor = Color(0xFF020e0a); //Color(0xFF0D0A0B);
const darkThemeTextColor = Color(0xFFebfcf7); //Color(0xFFFDFFFC);
const primaryColor = Color(0xFF1A936F);
const secondaryColor = Color(0xFF1a7b93);
const tertiaryColor = Color(0xFF931a3e); //Color(0xFFE26D5A);

const lightColor = Color(0xFFebfcf7); //Color(0xFFFDFFFC);
const elevatedLightColor = Color(0xFFdbf9f0);
ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    useMaterial3: true,
    canvasColor: Colors.transparent,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: lightColor,
      secondary: secondaryColor,
      onSecondary: lightColor,
      error: tertiaryColor,
      onError: lightColor,
      background: lightColor,
      onBackground: lowerDarkColor,
      surface: elevatedLightColor,
      onSurface: lowerDarkColor,
      outline: primaryColor,
    ),
    cardTheme: CardTheme(
      surfaceTintColor: elevatedLightColor,
      elevation: 2,
    ),
    scaffoldBackgroundColor: lightColor,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: lightThemeTextColor,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      surfaceTintColor: lightColor,
      backgroundColor: lightColor,
      indicatorColor: primaryColor,
    ),
    chipTheme: ChipThemeData(
      selectedColor: primaryColor,
    ),
    shadowColor: Colors.grey.withOpacity(0.3),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      prefixIconColor: primaryColor,
      labelStyle: TextStyle(
        fontSize: 25.0,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: tertiaryColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: tertiaryColor,
          width: 1.0,
        ),
      ),
    ),
  );
}

const darkText = Color(0xFFB7B7B7);
const lowerDarkColor = Color(0xFF020e0a); //Color(0xFF090707);
const elevatedDarkColor = Color(0xFF051e17); //Color(0xFF100F0F);
const popupColor = Color(0xFF082f23);
ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    useMaterial3: true,
    canvasColor: Colors.transparent,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: lowerDarkColor,
      secondary: secondaryColor,
      onSecondary: lowerDarkColor,
      error: tertiaryColor,
      onError: lowerDarkColor,
      background: lowerDarkColor,
      onBackground: darkText,
      surface: elevatedDarkColor,
      onSurface: darkText,
      outline: primaryColor,
    ),
    cardTheme: CardTheme(
      surfaceTintColor: elevatedDarkColor,
      elevation: 0,
    ),
    scaffoldBackgroundColor: lowerDarkColor,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: darkText,
      ),
    ),
    chipTheme: ChipThemeData(
      selectedColor: primaryColor,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      surfaceTintColor: lowerDarkColor,
      backgroundColor: lowerDarkColor,
      indicatorColor: primaryColor,
    ),
    shadowColor: Colors.transparent,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      prefixIconColor: primaryColor,
      labelStyle: TextStyle(
        fontSize: 25.0,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: tertiaryColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: tertiaryColor,
          width: 1.0,
        ),
      ),
    ),
  );
}
