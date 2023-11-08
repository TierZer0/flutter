import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_animation/weather_animation.dart';
import 'package:weather_zero/weather/config/base.weather.dart';

class ClearWeather extends ConsumerWidget {
  final bool daylight;

  const ClearWeather({
    Key? key,
    required this.daylight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseWeather(
      daylight: daylight,
      lightColors: const [
        Color(0xFFFF8f00),
        Color(0xFF29b6f6),
        Color(0xFFE1F5FE),
      ],
      darkColors: const [
        Color(0x5601579b),
        Color(0xff455a64),
      ],
      lightChildren: const [
        SunWidget(),
      ],
      darkChildren: const [
        WindWidget(),
      ],
    );
  }
}
