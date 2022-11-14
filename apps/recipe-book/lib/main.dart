import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:recipe_book/app_model.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/pages/login.page.dart';
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
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  AppModel appModel = AppModel();

  @override
  void initState() {
    super.initState();
  }

  void _initIsLoggedIn() async {
    appModel.uid = await appModel.appPreferences.getUserUIDPref();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        systemNavigationBarColor: primaryColor,
      ),
    );
    return ChangeNotifierProvider<AppModel>.value(
      value: appModel,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: buildLightTheme(),
            home: Scaffold(
              resizeToAvoidBottomInset: true,
              body: appModel.uid != '' ? Container() : LoginPage(),
            ),
          );
        },
      ),
    );
  }
}
