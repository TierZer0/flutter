import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/app_model.dart';
// import 'package:provider/provider.dart';
import 'package:recipe_book/main.view.dart';
import 'package:recipe_book/views/auth/auth.dart';
import 'package:recipe_book/providers/app/app.state.dart';
import 'package:recipe_book/providers/app/providers.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/views/community/by_category.view.dart';
// import 'package:recipe_book/views/login/login.view.dart';
import 'package:recipe_book/views/new-recipe/new-recipe.view.dart';
import 'package:recipe_book/views/recipe-book.view.dart';
import 'package:recipe_book/views/recipe/recipe.view.dart';
import 'package:recipe_book/preferences/app_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}

const seed = Color(0xFF82C09A);

class App extends ConsumerWidget {
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          return AuthView();
        },
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) {
              return AuthView(
                route: AuthViewRoutes.login,
              );
              // return LoginView();
            },
          ),
          GoRoute(
            path: 'createAccount',
            builder: (context, state) {
              return AuthView(
                route: AuthViewRoutes.createAccount,
              );
              // return CreateAccountView();
            },
          ),
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
        },
      ),
      GoRoute(
        path: '/community',
        builder: (context, state) {
          return MainView();
        },
        routes: [
          GoRoute(
            path: 'byCategory/:category',
            builder: (context, state) {
              return ByCategoryCommunityView(
                category: state.params['category']!,
              );
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: seed,
        // statusBarIconBrightness: ref.watch(app).brigthness,
        // systemNavigationBarIconBrightness: ref.watch(app).brigthness,
      ),
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: seed,
        fontFamily: 'Lato',
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          // surfaceTintColor: Colors.transparent,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: seed,
        fontFamily: 'Lato',
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          // surfaceTintColor: Colors.transparent,
        ),
      ),
      themeMode: ref.watch(app).themeMode,
    );
  }
}
