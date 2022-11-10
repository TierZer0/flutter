import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const userUID = "USERUID";

  setUserUIDPref(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userUID, value);
  }

  Future<String> getUserUIDPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUID) ?? '';
  }
}
