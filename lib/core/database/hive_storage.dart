import 'dart:convert';

import 'package:final_app_folder/data/model/weather_model.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class HiveUtils {
  static Box? _ourDataBase;

  static initDB() {
    _ourDataBase = Hive.box('weatherDB');
  }

  static storeWeatherData(WeatherModel weather) {
    final Map<String, dynamic> weatherJson = weather.toJson();
    final String encodedJson = jsonEncode(weatherJson);
    // print('Save data:$encodedJson');
    _ourDataBase?.put(WeatherConstants.weatherKey, encodedJson);
  }

  static WeatherModel? fetchWeatherDataFromHive() {
    try {
      final String? storedWeatherData =
          _ourDataBase?.get(WeatherConstants.weatherKey);
      if (storedWeatherData != null) {
        final Map<String, dynamic> decodeData = jsonDecode(storedWeatherData);
        final WeatherModel model = WeatherModel.fromJson(decodeData);

        return model;
      } else {
        return null;
      }

      // print('Fetched Data:$storedWeatherData');
    } catch (e) {
      // print(e);
      return null;
    }
  }
}
