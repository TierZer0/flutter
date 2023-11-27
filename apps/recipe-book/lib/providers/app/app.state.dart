import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/app/app.state.model.dart';

class AppState extends StateNotifier<AppStateModel> {
  AppState() : super(AppStateModel.initial());

  AppStateModel _prevState = AppStateModel.initial();

  get brigthness => state.darkMode ? Brightness.dark : Brightness.light;
  get themeMode => ThemeMode.system;

  get lastRoute => state.lastRoute;
}
