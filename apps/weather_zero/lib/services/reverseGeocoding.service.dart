import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_zero/models/gecoding.model.dart';

class ReverseGeocodingService {
  final baseURL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=';

  Future<IGoogleGeocodingModel> getReverseGeocoding(double latitude, double longitude) async {
    String url = '$baseURL$latitude,$longitude&key=${dotenv.env['GOOGLE_MAPS_KEY']}';

    final response = await Dio().get(url);

    print(IGoogleGeocodingModel.fromMap(response.data).city);

    return IGoogleGeocodingModel.fromMap(response.data);
  }
}

final ReverseGeocodingService reverseGeocodingService = ReverseGeocodingService();
