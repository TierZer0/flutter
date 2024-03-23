import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/routes/auth/auth.main.dart';
import 'package:recipe_book/providers/app/providers.dart';
import 'package:recipe_book/routes/recipe/recipe.main.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

const primary = Color(0xFFec6d13);

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

class App extends ConsumerWidget {
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          return AuthMainRoute();
        },
      ),
      // GoRoute(
      //   path: '/newRecipe',
      //   builder: (context, state) {
      //     return NewPage();
      //   },
      //   routes: [
      //     GoRoute(
      //       path: ':recipeId',
      //       builder: (context, state) {
      //         return NewPage(id: state.params['recipeId']);
      //       },
      //     )
      //   ],
      // ),
      GoRoute(
        path: '/recipe/:recipeId',
        builder: (context, state) {
          return RecipeMain(
            recipeId: state.params['recipeId']!,
          );
        },
      ),
      // GoRoute(
      //   path: '/recipeBook/:recipeBookId',
      //   builder: (context, state) {
      //     return RecipeBookPage(
      //       recipeBookId: state.params['recipeBookId']!,
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/community',
      //   builder: (context, state) {
      //     return AuthView();
      //   },
      //   routes: [
      //     GoRoute(
      //       path: 'byCategory/:category',
      //       builder: (context, state) {
      //         return ByCategoryCommunityView(
      //           category: state.params['category']!,
      //         );
      //       },
      //     ),
      //   ],
      // ),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const lightColorTheme = ColorScheme.light(
      primary: primary,
      secondary: Color(0xFFe5ddd6),
      background: Colors.white,
      onBackground: Color(0xFF161614),
      surface: Color(0xFFf4f2f0),
      onSurface: Color(0xFF161614),
    );

    const darkColorTheme = ColorScheme.dark(
      primary: primary,
      secondary: Color(0xFF392f27),
      background: Color(0xFF181411),
      onBackground: Color(0xFFefefef),
      surface: Color(0xFF27201c),
      onSurface: Color(0xFFefefef),
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: lightColorTheme.primary,
        // statusBarIconBrightness: ref.watch(app).brigthness,
        // systemNavigationBarIconBrightness: ref.watch(app).brigthness,
      ),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Lato',
        colorScheme: lightColorTheme,
        appBarTheme: AppBarTheme(
          color: lightColorTheme.background,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: lightColorTheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: MaterialStatePropertyAll(lightColorTheme.surface),
          elevation: MaterialStatePropertyAll(0),
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              color: lightColorTheme.onSurface,
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: lightColorTheme.background,
          elevation: 0,
          indicatorColor: lightColorTheme.secondary,
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(
              color: lightColorTheme.onBackground,
            ),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: primary,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: darkColorTheme,
        appBarTheme: AppBarTheme(
          color: darkColorTheme.background,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: darkColorTheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: MaterialStatePropertyAll(darkColorTheme.surface),
          elevation: MaterialStatePropertyAll(0),
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              color: darkColorTheme.onSurface,
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkColorTheme.background,
          elevation: 0,
          indicatorColor: darkColorTheme.secondary,
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(
              color: darkColorTheme.onBackground,
            ),
          ),
        ),
      ),
      themeMode: ref.watch(app).themeMode,
    );
  }
}
