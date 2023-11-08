import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:weather_zero/main.view.dart';
import 'package:weather_zero/states/app.state.dart';
import 'package:weather_zero/states/theme.state.dart';

void main() async {
  setPathUrlStrategy();
  await dotenv.load(fileName: "assets/.env");
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}

final appStateProvider = StateProvider<AppState>(
  (ref) => AppState(),
);

final themeStateProvider = StateProvider<ThemeState>((ref) => ThemeState());

class App extends HookConsumerWidget {
  App({super.key});

  final GoRouter _goRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainView(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      final AsyncValue<ThemeState> themeState = ref.watch(themeStateFutureProvider);

      return switch (themeState) {
        AsyncData(:final value) => MaterialApp.router(
            routerConfig: _goRouter,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: value.seed,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              colorSchemeSeed: value.seed,
            ),
            themeMode: value.isDark ? ThemeMode.dark : ThemeMode.light,
          ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error, :final stackTrace) => const Center(child: Text('Error')),
        _ => const Center(child: Text('Error')),
      };
    });
  }
}
