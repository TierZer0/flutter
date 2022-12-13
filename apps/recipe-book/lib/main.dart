import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:recipe_book/app_model.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/main.view.dart';
import 'package:recipe_book/preferences/app_preferences.dart';
import 'package:recipe_book/styles.dart';
import 'firebase_options.dart';

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
  AppState createState() => AppState();
}

class AppState extends State<App> {
  AppModel appModel = AppModel();
  AppPreferences appPreferences = AppPreferences();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<AppModel>.value(
        value: appModel,
        child: Consumer<AppModel>(
          builder: (context, value, child) {
            ThemeData theme =
                appModel.theme ? buildDarkTheme() : buildLightTheme();
            SystemChrome.setSystemUIOverlayStyle(
              appModel.theme
                  ? const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: primaryColor,
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarIconBrightness: Brightness.dark,
                    )
                  : const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: primaryColor,
                      statusBarIconBrightness: Brightness.dark,
                      systemNavigationBarIconBrightness: Brightness.light,
                    ),
            );
            appPreferences
                .getUserUIDPref()
                .then((value) => appModel.uid = value);
            return MainView(theme, appModel);
          },
        ),
      ),
    );
  }
}
