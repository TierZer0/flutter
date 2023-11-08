import 'package:flutter/material.dart';

class ThemeStateModel {
  final bool isDark;
  final Color seed;

  ThemeStateModel({
    required this.isDark,
    required this.seed,
  });

  factory ThemeStateModel.initial() {
    return ThemeStateModel(
      isDark: false,
      seed: const Color(0xFF29b6f6),
    );
  }

  ThemeStateModel copyWith({
    bool? isDark,
    Color? seed,
  }) {
    return ThemeStateModel(
      isDark: isDark ?? this.isDark,
      seed: seed ?? this.seed,
    );
  }
}
