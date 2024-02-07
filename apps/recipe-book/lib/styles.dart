import 'package:flutter/material.dart';

const primary = Color(0xFF1D3557);
const secondary = Color(0xFFA8DADC);
final tertiary = Color(0xFF2F578F);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Lato',
  colorScheme: ColorScheme.light(
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
  ),
  appBarTheme: AppBarTheme(
    color: primary,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  searchBarTheme: SearchBarThemeData(
    backgroundColor: MaterialStatePropertyAll(tertiary),
    textStyle: MaterialStatePropertyAll(
      TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: primary,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: secondary,
  ),
);
