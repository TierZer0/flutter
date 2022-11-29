import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:recipe_book/app_model.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/login.page.dart';
import 'package:recipe_book/pages/profile.page.dart';
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
                      navs: [
                        CustomIconButton(
                          color: appModel.view == 'Home'
                              ? tertiaryColor
                              : (theme.textTheme.titleLarge?.color)!
                                  .withOpacity(0.75),
                          icon: const Icon(
                            Icons.home_outlined,
                          ),
                          onPressed: () => changeView('Home'),
                          iconSize: 45.0,
                        ),
                        CustomIconButton(
                          color: appModel.view == 'Recipes'
                              ? tertiaryColor
                              : (theme.textTheme.titleLarge?.color)!
                                  .withOpacity(0.75),
                          icon: const Icon(
                            Icons.book_outlined,
                          ),
                          onPressed: () => changeView('Recipes'),
                          iconSize: 40.0,
                        ),
                        CustomIconButton(
                          color: (theme.textTheme.titleLarge?.color)!
                              .withOpacity(0.75),
                          icon: const Icon(
                            Icons.add,
                          ),
                          onPressed: () {},
                          iconSize: 65.0,
                        ),
                        CustomIconButton(
                          color: appModel.view == 'Favorites'
                              ? tertiaryColor
                              : (theme.textTheme.titleLarge?.color)!
                                  .withOpacity(0.75),
                          icon: const Icon(
                            Icons.favorite_outline,
                          ),
                          onPressed: () => changeView('Favorites'),
                          iconSize: 40.0,
                        ),
                        CustomIconButton(
                          color: appModel.view == 'Profile'
                              ? tertiaryColor
                              : (theme.textTheme.titleLarge?.color)!
                                  .withOpacity(0.75),
                          icon: const Icon(
                            Icons.person_outline_outlined,
                          ),
                          onPressed: () => changeView('Profile'),
                          iconSize: 40.0,
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
