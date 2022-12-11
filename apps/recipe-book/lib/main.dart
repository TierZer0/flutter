import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:recipe_book/app_model.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/login.page.dart';
import 'package:recipe_book/pages/profile.page.dart';
import 'package:recipe_book/preferences/app_preferences.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';
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
  AppPreferences appPreferences = AppPreferences();

  var views = {
    "Home": HomePage(),
    "Profile": ProfilePage(),
  };

  @override
  void initState() {
    super.initState();
  }

  void changeView(String view) async {
    appModel.view = view;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
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
          appPreferences.getUserUIDPref().then((value) => appModel.uid = value);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: Scaffold(
              resizeToAvoidBottomInset: true,
              body: appModel.uid == '' ? LoginPage() : views[appModel.view],
              bottomNavigationBar: appModel.uid != ''
                  ? CustomBottomNavBar(
                      height: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      useMat3: true,
                      activeColor: tertiaryColor,
                      mat3Navs: [
                        CustomNavBarItem(
                          label: 'Home',
                          isActive: appModel.view == 'Home',
                          onPressed: () => changeView('Home'),
                          icon: const Icon(
                            Icons.home_outlined,
                            size: 35.0,
                          ),
                        ),
                        CustomNavBarItem(
                          label: 'Recipes',
                          isActive: appModel.view == 'Recipes',
                          onPressed: () => changeView('Recipes'),
                          icon: const Icon(
                            Icons.book_outlined,
                            size: 35.0,
                          ),
                        ),
                        CustomNavBarItem(
                          label: 'New',
                          isActive: false,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            size: 35.0,
                          ),
                        ),
                        CustomNavBarItem(
                          label: 'Favorites',
                          isActive: appModel.view == 'Favorites',
                          onPressed: () => changeView('Favorites'),
                          icon: const Icon(
                            Icons.favorite_outline,
                            size: 35.0,
                          ),
                        ),
                        CustomNavBarItem(
                          label: 'Home',
                          isActive: appModel.view == 'Profile',
                          onPressed: () => changeView('Profile'),
                          icon: const Icon(
                            Icons.person_outline_outlined,
                            size: 35.0,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
