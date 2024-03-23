import 'package:flutter/material.dart';

class AppStateModel {
  final bool darkMode;
  final String lastRoute;
  final ThemeMode themeMode;

  AppStateModel({
    required this.darkMode,
    required this.lastRoute,
    required this.themeMode,
  });

  factory AppStateModel.initial() {
    return AppStateModel(
      darkMode: false,
      lastRoute: '/',
      themeMode: ThemeMode.system,
    );
  }

  AppStateModel copyWith({
    bool? darkMode,
    String? lastRoute,
  }) {
    return AppStateModel(
      darkMode: darkMode ?? this.darkMode,
      lastRoute: lastRoute ?? this.lastRoute,
      themeMode: themeMode,
    );
  }
}
