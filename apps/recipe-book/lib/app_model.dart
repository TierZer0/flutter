import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/preferences/app_preferences.dart';

class AppModel extends ChangeNotifier {
  AppPreferences appPreferences = AppPreferences();

  // USER Login State
  String _userUID = '';
  String get uid => _userUID;
  set uid(String value) {
    _userUID = value;
    appPreferences.setUserUIDPref(value);
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

  //CURRENT THEME state
  bool _theme = false;
  bool get theme => _theme;
  set theme(bool value) {
    _theme = value;
    appPreferences.setCurrentTheme(value);
    notifyListeners();
  }

  //CURRENT RECIPE BOOK state
  RecipeBook _recipeBook = RecipeBook('', '', '', [], '', 0);
  RecipeBook get recipeBook => _recipeBook;
  set recipeBook(RecipeBook book) {
    _recipeBook = book;
    notifyListeners();
  }
}
