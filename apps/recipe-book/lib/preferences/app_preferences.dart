import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const userUID = "USERUID";
  static const view = "VIEW";
  static const theme = "THEME";
  static const lastLogin = "LASTLOGIN";

  setUserUID(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userUID, value);
  }

  Future<String> getUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUID) ?? '';
  }

  setLastLogin(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(lastLogin, value);
  }

  Future<int?> getLastLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(lastLogin) ?? null;
  }

  setCurrentView(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(view, value);
  }

  Future<String> getCurrentView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(view) ?? '';
  }

  setCurrentTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(theme, value);
  }

  Future<bool> getCurrentTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(theme) ?? false;
  }
}
