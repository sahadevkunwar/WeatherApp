import 'package:dio/dio.dart';
import 'package:final_app_folder/core/database/hive_storage.dart';
import 'package:final_app_folder/data/repo/weather_repo.dart';
import 'package:final_app_folder/data/source/weather_source.dart';
import 'package:final_app_folder/presentation/cubit/weather_cubit/weather_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/route/auto_route.dart';

GetIt getIt = GetIt.instance;

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //Hive.registerAdapter(WeatherAdapter());
  await Hive.openBox('weatherDB');

  await HiveUtils.initDB();
  getIt.registerLazySingleton<HiveUtils>(() => HiveUtils());

  // HiveUtils.initDB();
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<WeatherSource>(() => WeatherSource());
  getIt.registerLazySingleton<WeatherRepo>(
      () => WeatherRepo(getIt<WeatherSource>()));
  getIt.registerLazySingleton<WeatherCubit>(
      () => WeatherCubit(getIt<WeatherRepo>()));
}
