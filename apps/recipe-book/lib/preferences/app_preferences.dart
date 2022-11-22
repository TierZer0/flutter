import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const userUID = "USERUID";
  static const view = "VIEW";

  setUserUIDPref(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userUID, value);
  }

  Future<String> getUserUIDPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUID) ?? '';
  }

  setCurrentView(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(view, value);
  }

  Future<String> getCurrentView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(view) ?? '';
  }
}
