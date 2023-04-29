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
import 'package:recipe_book/pages/recipe/recipe.page.dart';
import 'package:recipe_book/preferences/app_preferences.dart';
import 'package:recipe_book/styles.dart';
import 'firebase_options.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp(App());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppModel()),
      ],
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  // AppModel appModel = AppModel();

  @override
  void initState() {
    super.initState();
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      AppPreferences appPreferences = AppPreferences();
      return appPreferences.getUserUIDPref().then((value) {
        context.read<AppModel>().uid = value;
        if (value == '') {
          return '/login';
        } else {
          return state.location == '/login' ? '/' : state.location;
        }
      });
      // final appModel = Provider.of<AppModel>(context);
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return LoginPage();
        },
      ),
      GoRoute(
        path: '/newRecipe',
        builder: (context, state) {
          return NewPage();
        },
        routes: [
          GoRoute(
            path: ':recipeId',
            builder: (context, state) {
              return NewPage(id: state.params['recipeId']);
            },
          )
        ],
      ),
      GoRoute(
        path: '/newRecipeBook',
        builder: (context, state) {
          return NewRecipeBookPage();
        },
      ),
      GoRoute(
        path: '/recipe/:recipeId/:source',
        builder: (context, state) {
          return RecipePage(
            recipeId: state.params['recipeId']!,
            source: state.params['source']!,
          );
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          return MainView();
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, value, child) {
        ThemeData theme = context.read<AppModel>().theme ? buildDarkTheme() : buildLightTheme();
        SystemChrome.setSystemUIOverlayStyle(
          context.read<AppModel>().theme
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
        // appPreferences.getUserUIDPref().then((value) => context.read<AppModel>().uid = value);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: theme,
        );
      },
    );
  }
}
