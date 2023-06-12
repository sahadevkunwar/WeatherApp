import 'package:dio/dio.dart';
import 'package:final_app_folder/bootstrap.dart';
import 'package:final_app_folder/core/base/base_source.dart';

import '../model/weather_model.dart';

class WeatherSource extends BaseSource {
  WeatherSource() : _dioClient = getIt<Dio>();
  final Dio? _dioClient;

  Future<WeatherModel> searchWeather({required String queryFromRepo}) async {
    return networkHandler(
      request: (Dio dio) => dio.get(
          'https://api.weatherapi.com/v1/forecast.json?key=66eb35a4c0134ef3a23153944222403&q=$queryFromRepo&days=1&aqi=no&alerts=no'),
      onResponse: (Map<String, dynamic> data) {
        final WeatherModel weatherModel = WeatherModel.fromJson(data);
        return weatherModel;
      },
    );
  }
}
