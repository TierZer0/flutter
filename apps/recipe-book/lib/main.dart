import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/app_model.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/main.view.dart';
import 'package:recipe_book/views/login/create-account.view.dart';
import 'package:recipe_book/views/login/login.view.dart';
import 'package:recipe_book/views/new-recipe/new-recipe.view.dart';
import 'package:recipe_book/views/recipe-book.view.dart';
import 'package:recipe_book/views/recipe/recipe.view.dart';
import 'package:recipe_book/preferences/app_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();

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
        if (state.location.contains('/login/createAccount')) {
          return state.location;
        }
        if (value == '') {
          return '/login';
        } else {
          return state.location == '/login' ? '/' : state.location;
        }
      });
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return LoginPage();
        },
        routes: [
          GoRoute(
            path: 'createAccount/:isSSO',
            builder: (context, state) {
              return CreateAccount(
                isSSO: state.params['isSSO'] == 'true',
              );
            },
          )
        ],
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
        path: '/recipe/:recipeId',
        builder: (context, state) {
          return RecipePage(
            recipeId: state.params['recipeId']!,
          );
        },
      ),
      GoRoute(
          path: '/recipeBook/:recipeBookId',
          builder: (context, state) {
            return RecipeBookPage(
              recipeBookId: state.params['recipeBookId']!,
            );
          }),
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
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Color(0xFF006D43),
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );

        var mode = context.read<AppModel>().theme ? ThemeMode.dark : ThemeMode.light;
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: Color(0xFF006D43),
            fontFamily: 'Lato',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorSchemeSeed: Color(0xFF006D43),
            fontFamily: 'Lato',
          ),
          themeMode: mode,
        );
      },
    );
  }
}
