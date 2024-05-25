import 'package:flutter/material.dart';
import 'package:recipe_book/preferences/app_preferences.dart';

import 'models/models.dart';

class AppModel extends ChangeNotifier {
  AppPreferences appPreferences = AppPreferences();

  // USER Login State
  String _userUID = '';
  String get uid => _userUID;
  set uid(String value) {
    _userUID = value;
    appPreferences.setUserUID(value);
    notifyListeners();
  }

  // CURRENT VIEW state
  String _view = 'Home';
  String get view => _view;
  set view(String value) {
    _view = value;
    appPreferences.setCurrentView(value);
    notifyListeners();
  }

  // CURRENT THEME state
  bool _theme = false;
  bool get theme => _theme;
  set theme(bool value) {
    _theme = value;
    appPreferences.setCurrentTheme(value);
    notifyListeners();
  }

  // CURRENT RECIPE BOOK state
  RecipeBook _recipeBook = RecipeBook(
    name: '',
    recipeIds: [],
    createdBy: '',
    likes: 0,
  );
  RecipeBook get recipeBook => _recipeBook;
  set recipeBook(RecipeBook book) {
    _recipeBook = book;
    //notifyListeners();
  }

  // CURRENT SEARCH state
  String _search = '';
  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }
}
