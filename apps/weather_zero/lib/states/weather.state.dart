import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_zero/main.dart';
import 'package:weather_zero/services/weatherkit.service.dart';

final weatherProvider = FutureProvider((ref) async {
  final appState = ref.watch(appStateProvider.notifier).state;
  final weather = await weatherKitSerivce.getWeather(
    appState.latitude,
    appState.longitude,
    'America/New_York',
  );
  return weather;
});
