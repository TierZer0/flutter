import 'dart:convert';

import 'package:weather_zero/models/current_weather.model.dart';

class IWeatherResponse {
  final ICurrentWeather currentWeather;
  dynamic forecastDaily;
  dynamic forecastHourly;
  dynamic forecastNextHour;
  dynamic weatherAlerts;

  IWeatherResponse({
    required this.currentWeather,
    this.forecastDaily,
    this.forecastHourly,
    this.forecastNextHour,
    this.weatherAlerts,
  });

  factory IWeatherResponse.fromMap(Map<String, dynamic> map) {
    return IWeatherResponse(
      currentWeather: ICurrentWeather.fromMap(map),
      forecastDaily: map['forecastDaily'],
      forecastHourly: map['forecastHourly'],
      forecastNextHour: map['forecastNextHour'],
      weatherAlerts: map['weatherAlerts'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentWeather': currentWeather,
      'forecastDaily': forecastDaily,
      'forecastHourly': forecastHourly,
      'forecastNextHour': forecastNextHour,
      'weatherAlerts': weatherAlerts,
    };
  }

  factory IWeatherResponse.fromJson(String source) =>
      IWeatherResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
