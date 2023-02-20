import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/app_model.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/main.view.dart';
import 'package:recipe_book/pages/login.page.dart';
import 'package:recipe_book/pages/new-recipe/new-recipe-book.page.dart';
import 'package:recipe_book/pages/new-recipe/new-recipe.page.dart';
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

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      final appModel = Provider.of<AppModel>(context);
      if (appModel.uid == '') {
        return '/login';
      } else {
        return '/';
      }
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return LoginPage();
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          return MainView();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'newRecipe',
            builder: (context, state) {
              return const NewPage();
            },
          ),
          GoRoute(
            path: 'newRecipeBook',
            builder: (context, state) {
              return const NewRecipeBookPage();
            },
          ),
        ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
      value: appModel,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          ThemeData theme = appModel.theme ? buildDarkTheme() : buildLightTheme();
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
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            theme: theme,
          );
        },
      ),
    );
  }
}
