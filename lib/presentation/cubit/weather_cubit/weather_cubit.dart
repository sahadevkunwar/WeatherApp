import 'package:bloc/bloc.dart';
import 'package:final_app_folder/data/model/weather_model.dart';
import 'package:final_app_folder/data/repo/weather_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_cubit.freezed.dart';
part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepo) : super(const WeatherState.initial());
  final WeatherRepo _weatherRepo;

  Future<void> searchWeather({required String queryFromUI}) async {
    emit(const WeatherState.initial());
    final response =
        await _weatherRepo.searchWeather(queryFromCubit: queryFromUI);

    response.fold((error) => emit(WeatherState.error(error: error.toString())),
        (movieModel) => emit(WeatherState.fetched(weatherModel: movieModel)));
    // handleBlocData(
    //   response: await _weatherRepo.searchWeather(queryFromCubit: queryFromUI),
    //   onData: (weatherDetail) {
    //     // print("Weather data at Cubit: ${weatherDetail.toJson()}");
    //     emit(WeatherState.fetched(weatherModel: weatherDetail));
    //     // emit(const WeatherState.fetching());
    //   },
    //   onFailure: (String? error) {
    //     emit(WeatherState.error(error: error!));
    //   },
    // );

    // final response =
    // await _movieRepository.searchMovie(queryFromCubit: queryFromUI);
    // response.fold(
    //         (error) => emit(SearchedError(errorMessage: error.toString())),
    //         (movieModel) => _checkResultResponse(movieModel));
  }
}
