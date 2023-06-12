part of 'weather_cubit.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState.initial() = _Initial;

  const factory WeatherState.loading() = _Loading;

  const factory WeatherState.fetched({required WeatherModel weatherModel}) =
      _Fetched;

  const factory WeatherState.error({required String error}) = _Error;
}
