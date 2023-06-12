import 'package:dartz/dartz.dart';
import 'package:final_app_folder/core/base/base_repository.dart';
import 'package:final_app_folder/data/source/weather_source.dart';

import '../model/weather_model.dart';

class WeatherRepo extends BaseRepository {
  WeatherRepo(this.weatherSource);

  WeatherSource weatherSource;

  Future<Either<String?, WeatherModel>> searchWeather(
      {required String queryFromCubit}) {
    return handleNetworkCall(
        call: weatherSource.searchWeather(queryFromRepo: queryFromCubit),
        onSuccess: (data) => data);
  }
}
