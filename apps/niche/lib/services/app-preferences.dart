import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const themeSetting = "THEMESETTING";
  static const currentView = "CURRENTVIEW";
  static const userUID = "USERUID";

  setUserUIDPref(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userUID, value);
  }

  Future<String> getUserUIDPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUID) ?? '';
  }

  setViewPref(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(currentView, value);
  }

  Future<String> getViewPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentView) ?? 'niches';
  }

  setThemePref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeSetting, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeSetting) ?? false;
  }
}
