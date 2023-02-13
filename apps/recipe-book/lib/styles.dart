import 'package:flutter/material.dart';

const lightThemeTextColor = Color(0xFF0D0A0B);
const darkThemeTextColor = Color(0xFFFDFFFC);
const primaryColor = Color(0xFF1A936F);
const secondaryColor = Color(0xFF009FFD);
const tertiaryColor = Color(0xFFE26D5A);

const lightColor = Color(0xFFFDFFFC);
ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    useMaterial3: true,
    canvasColor: Colors.transparent,
    backgroundColor: darkThemeTextColor,
    scaffoldBackgroundColor: darkThemeTextColor,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: lightThemeTextColor,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      surfaceTintColor: darkThemeTextColor,
      backgroundColor: darkThemeTextColor,
      indicatorColor: primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkThemeTextColor,
      foregroundColor: lightThemeTextColor,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: lightThemeTextColor,
    ),
    shadowColor: Colors.grey.withOpacity(0.3),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: lightThemeTextColor,
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
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: tertiaryColor,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: tertiaryColor,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      errorStyle: TextStyle(
        color: tertiaryColor,
      ),
    ),
  );
}

const darkText = Color(0xFFB7B7B7);
const lowerDarkColor = Color(0xFF090707);
const elevatedDarkColor = Color(0xFF100F0F);
ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    useMaterial3: true,
    canvasColor: Colors.transparent,
    backgroundColor: elevatedDarkColor,
    scaffoldBackgroundColor: lowerDarkColor,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: darkText,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      surfaceTintColor: lowerDarkColor,
      backgroundColor: lowerDarkColor,
      indicatorColor: primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lowerDarkColor,
      foregroundColor: darkText,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: darkText,
    ),
    shadowColor: Colors.transparent,
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
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: tertiaryColor,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
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
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: tertiaryColor,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      errorStyle: TextStyle(
        color: tertiaryColor,
      ),
    ),
  );
}
