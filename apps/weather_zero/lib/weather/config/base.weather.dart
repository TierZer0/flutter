import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_animation/weather_animation.dart';
import 'package:weather_zero/main.dart';
import 'package:weather_zero/states/theme.state.dart';

class BaseWeather extends ConsumerStatefulWidget {
  final bool daylight;
  final List<Color> lightColors;
  final List<Color> darkColors;
  final List<Widget> lightChildren;
  final List<Widget> darkChildren;

  const BaseWeather({
    Key? key,
    required this.daylight,
    required this.lightColors,
    required this.darkColors,
    required this.lightChildren,
    required this.darkChildren,
  }) : super(key: key);

  @override
  _BaseWeatherState createState() => _BaseWeatherState();
}

class _BaseWeatherState extends ConsumerState<BaseWeather> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final themeState = ref.watch(themeStateProvider);
    themeState.setSeed(widget.daylight ? widget.lightColors[0] : widget.darkColors[0]);
    themeState.setTheme(!widget.daylight);
    ref.refresh(themeStateFutureProvider);
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.daylight) {
      true => WrapperScene(
          colors: widget.lightColors,
          children: widget.lightChildren,
        ),
      false => WrapperScene(
          colors: widget.darkColors,
          children: widget.darkChildren,
        ),
    };
  }
}
