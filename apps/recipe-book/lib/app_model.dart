import 'package:flutter/material.dart';
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
}
