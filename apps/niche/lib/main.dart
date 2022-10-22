import 'package:Niche/services/app-preferences.dart';
import 'package:Niche/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './pages/main.page.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  AppModel appModel = AppModel();

  @override
  void initState() {
    super.initState();
    _initAppTheme();
  }

  void _initAppTheme() async {
    appModel.darkTheme = await appModel.appPreferences.getTheme();
  }

  void _initIsLoggedin() async {
    appModel.uid = await appModel.appPreferences.getUserUIDPref();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
      value: appModel,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appModel.darkTheme ? buildDarkTheme() : buildLightTheme(),
            home: MainPage(),
          );
        },
      ),
    );
  }
}

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

  // Current View
  String _view = 'niches';
  String get view => _view;

  set view(String value) {
    _view = value;
    appPreferences.setViewPref(value);
    notifyListeners();
  }

  // Theme
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    appPreferences.setThemePref(value);
    notifyListeners();
  }
}
