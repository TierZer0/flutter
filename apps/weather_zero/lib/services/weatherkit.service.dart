import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_kit/weather_kit.dart';
import 'package:weather_zero/models/weather_response.model.dart';

const baseUrl = 'https://weatherkit.apple.com/api/v1';

enum EDataSet { currentWeather, forecastDaily, forecastHourly, forecastNextHour, weatherAlerts }

class WeatherKitSerivce {
  final weatherKit = WeatherKit();
  final dio = Dio();

  dynamic genToken() {
    return weatherKit.generateJWT(
      bundleId: dotenv.env['BUNDLE_ID']!,
      teamId: dotenv.env['TEAM_ID']!,
      keyId: dotenv.env['KEY_ID']!,
      pem: dotenv.env['KEY']!,
      expiresIn: const Duration(hours: 1),
    );
  }

  Future<IWeatherResponse> getWeather(double latitude, double longitude, String timezone) async {
    final token = genToken();

    String url =
        "$baseUrl/weather/en/$latitude/$longitude?dataSets=currentWeather,forecastDaily,forecastHourly,forecastNextHour&timezone=$timezone";

    final weather = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': token,
        },
      ),
    );

    return IWeatherResponse.fromMap(weather.data);
  }
}

final WeatherKitSerivce weatherKitSerivce = WeatherKitSerivce();
