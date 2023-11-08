import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_zero/main.dart';
import 'package:weather_zero/states/theme.state.model.dart';

class ThemeState extends StateNotifier<ThemeStateModel> {
  ThemeState() : super(ThemeStateModel.initial());

  ThemeStateModel get currState => state;

  void setTheme(bool isDark) {
    state = state.copyWith(isDark: isDark);
  }

  void setSeed(Color seed) {
    state = state.copyWith(seed: seed);
  }

  void reset() {
    state = ThemeStateModel.initial();
  }

  bool get isDark => state.isDark;
  Color get seed => state.seed;
}

final themeStateFutureProvider = FutureProvider((ref) {
  return Future.value(ref.watch(themeStateProvider));
});
