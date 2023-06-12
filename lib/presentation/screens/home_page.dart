import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:final_app_folder/core/route/auto_route.gr.dart';
import 'package:final_app_folder/presentation/cubit/weather_cubit/weather_cubit.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/database/hive_storage.dart';
import '../../data/model/weather_model.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? _weatherModel;
  late WeatherCubit weatherCubit;
  final CarouselController _carouselController = CarouselController();
  String finalDateTime = '';
  String finalDateTimeFromHive = '';
  String lastUpdatedDateTime = '';
  String lastUpdatedDateTimeHive = '';

  @override
  void initState() {
    super.initState();
    weatherCubit = context.read<WeatherCubit>();
    _weatherModel = HiveUtils.fetchWeatherDataFromHive();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherCubit, WeatherState>(
      listener: (context, state) {
        state.maybeWhen(
            orElse: () {},
            error: (error) {
              FloatingSnackBar(
                message: 'Something went wrong',
                context: context,
                textColor: Colors.white70,
                // textStyle: const TextStyle(color: Colors.red),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: Colors.red,
              );
            });
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: BlocBuilder<WeatherCubit, WeatherState>(
          bloc: weatherCubit,
          builder: (context, state) {
            return state.maybeWhen(orElse: () {
              if (_weatherModel == null) {
                return const Center(child: Text("Weather App"));
              }
              final int lastUpdatedTime =
                  _weatherModel!.current.lastUpdatedEpoch;
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch((lastUpdatedTime * 1000));
              String temp = DateFormat('h:mm a').format(dateTime);
              lastUpdatedDateTimeHive = temp;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () =>
                              context.router.push(const SearchRoute()),
                          icon: const Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              _weatherModel!.location.name,
                              style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70),
                            )),
                            Center(
                                child: Text(
                              _weatherModel!.location.localtime,
                              style: const TextStyle(color: Colors.white70),
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Center(
                                //   child: Image.network(
                                //       'http:${_weatherModel?.current.condition.icon}',
                                //       width: 150,
                                //       height: 150,
                                //       fit: BoxFit.fill),
                                // ),
                                CachedNetworkImage(
                                  imageUrl:
                                      'http:${_weatherModel!.current.condition.icon}',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Column(
                                  children: [
                                    Center(
                                        child: Text(
                                            '${_weatherModel!.current.tempC} °C',
                                            style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white70,
                                            ))),
                                    Center(
                                        child: Text(
                                      'Feels like: ${_weatherModel!.current.feelslikeC}',
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 150,
                              child: Stack(
                                children: [
                                  CarouselSlider.builder(
                                    carouselController: _carouselController,
                                    itemCount: _weatherModel!
                                        .forecast.forecastday[0].hour.length,
                                    itemBuilder: (context, index, realIndex) {
                                      ///Updated Time
                                      final int currentTime = _weatherModel!
                                          .forecast
                                          .forecastday[0]
                                          .hour[index]
                                          .timeEpoch;
                                      DateTime dateTime =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              (currentTime * 1000));
                                      String temp =
                                          DateFormat('h:mm a').format(dateTime);
                                      finalDateTimeFromHive = temp;
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            finalDateTimeFromHive,
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                          //  const SizedBox(width: 2),
                                          // Image.network(
                                          //   'http:${_weatherModel?.forecast?.forecastday?[0].hour?[index].condition?.icon}',
                                          //   width: 60,
                                          //   height: 60,
                                          //   fit: BoxFit.fill,
                                          // ),
                                          CachedNetworkImage(
                                            imageUrl:
                                                'http:${_weatherModel!.forecast.forecastday[0].hour[index].condition.icon}',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          //  const SizedBox(width: 2),
                                          Text(
                                            '${_weatherModel!.forecast.forecastday[0].hour[index].tempC}°C ',
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 150,
                                      viewportFraction: 0.3,
                                      aspectRatio: 1.0,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: false,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: false,
                                      onPageChanged: (index, reason) {
                                        // Handle page change event
                                      },
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        _carouselController.previousPage();
                                      },
                                      icon: const Icon(Icons.arrow_left,
                                          color: Colors.white70, size: 30),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        _carouselController.nextPage();
                                      },
                                      icon: const Icon(Icons.arrow_right,
                                          color: Colors.white70, size: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.sunny,
                                      size: 40, color: Colors.yellowAccent),
                                  const SizedBox(width: 5),
                                  const Text('UV index',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text('${_weatherModel!.current.uv}',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(thickness: 1, color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.sunny,
                                      size: 40, color: Colors.amber),
                                  const SizedBox(width: 5),
                                  const Text('Sunrise',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text(
                                      _weatherModel!.forecast.forecastday[0]
                                          .astro.sunrise,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(thickness: 1, color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.sunny_snowing,
                                      size: 40, color: Colors.amber),
                                  const SizedBox(width: 5),
                                  const Text('Sunset',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text(
                                      _weatherModel!
                                          .forecast.forecastday[0].astro.sunset,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(thickness: 1, color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.wind_power,
                                      size: 40, color: Colors.green),
                                  const SizedBox(width: 5),
                                  const Text('Wind',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text('${_weatherModel!.current.windKph} km/h',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(thickness: 1, color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.water_drop_outlined,
                                      size: 40, color: Colors.blue),
                                  const SizedBox(width: 5),
                                  const Text('Humidity',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text('${_weatherModel!.current.humidity}%',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(color: Colors.black, thickness: 1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text('Last updated:$lastUpdatedDateTimeHive',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              );
            }, fetched: (weatherData) {
              HiveUtils.storeWeatherData(weatherData);
              final int lastUpdatedTime = weatherData.current.lastUpdatedEpoch;
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(lastUpdatedTime * 1000);
              String temp = DateFormat('h:mm a').format(dateTime);
              lastUpdatedDateTime = temp;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () =>
                              context.router.push(const SearchRoute()),
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        height: 370,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              weatherData.location.name,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70),
                            )),
                            Center(
                                child: Text(
                              weatherData.location.localtime,
                              style: const TextStyle(color: Colors.white70),
                            )),

                            // Center(child: Text('${weatherData.current?.condition?.text}')),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Center(
                                //   child: Image.network(
                                //       'http:${weatherData.current.condition.icon}',
                                //       width: 150,
                                //       height: 150,
                                //       fit: BoxFit.fill),
                                // ),
                                Center(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'http:${weatherData.current.condition.icon}',
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Center(
                                        child: Text(
                                            '${weatherData.current.tempC} °C',
                                            style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white70))),
                                    Center(
                                        child: Text(
                                      'Feels like: ${weatherData.current.feelslikeC}',
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 150,
                            //
                            //   // width: MediaQuery
                            //   //     .of(context)
                            //   //     .size
                            //   //     .width,
                            //   child: ListView.builder(
                            //       scrollDirection: Axis.vertical,
                            //       itemCount:
                            //           weatherData.forecast?.forecastday![0].hour?.length,
                            //       itemBuilder: (context, index) {
                            //         return Column(
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           children: [
                            //             Text(
                            //                 '${weatherData.forecast?.forecastday![0].hour?[index].tempC}'),
                            //             const SizedBox(width: 5),
                            //             Image.network(
                            //               '${weatherData.forecast?.forecastday![0].hour?[index].condition?.icon}',
                            //               width: 50,
                            //               height: 50,
                            //               fit: BoxFit.fill,
                            //             ),
                            //           ],
                            //         );
                            //       }),
                            // ),
                            ///24 hour data
                            SizedBox(
                              height: 140,
                              child: Stack(
                                children: [
                                  CarouselSlider.builder(
                                    carouselController: _carouselController,
                                    itemCount: weatherData
                                        .forecast.forecastday[0].hour.length,
                                    itemBuilder: (context, index, realIndex) {
                                      ///Updated Time
                                      final int currentTime = weatherData
                                          .forecast
                                          .forecastday[0]
                                          .hour[index]
                                          .timeEpoch;
                                      DateTime dateTime =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              (currentTime * 1000));
                                      String temp =
                                          DateFormat('h:mm a').format(dateTime);
                                      finalDateTime = temp;
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            finalDateTime,
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),

                                          CachedNetworkImage(
                                            imageUrl:
                                                'http:${weatherData.forecast.forecastday[0].hour[index].condition.icon}',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          //  const SizedBox(width: 2),
                                          Text(
                                            '${weatherData.forecast.forecastday[0].hour[index].tempC}°C ',
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 112,
                                      viewportFraction: 0.3,
                                      aspectRatio: 1.0,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: false,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: false,
                                      onPageChanged: (index, reason) {
                                        // Handle page change event
                                      },
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        _carouselController.previousPage();
                                      },
                                      icon: const Icon(Icons.arrow_left),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        _carouselController.nextPage();
                                      },
                                      icon: const Icon(Icons.arrow_right),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.sunny,
                                    size: 40,
                                    color: Colors.yellow,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text('UV index',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white70,
                                      )),
                                  const Spacer(),
                                  Text('${weatherData.current.uv}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white70,
                                      )),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(color: Colors.black, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.sunny,
                                    size: 40,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text('Sunrise',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text(
                                      weatherData.forecast.forecastday[0].astro
                                          .sunrise,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(color: Colors.black, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.sunny_snowing,
                                      size: 40, color: Colors.amber),
                                  const SizedBox(width: 5),
                                  const Text('Sunset',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text(
                                      weatherData
                                          .forecast.forecastday[0].astro.sunset,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(color: Colors.black, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.wind_power,
                                      size: 40, color: Colors.green),
                                  const SizedBox(width: 5),
                                  const Text('Wind',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text('${weatherData.current.windKph} km/h',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(color: Colors.black, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.water_drop_outlined,
                                      size: 40, color: Colors.blue),
                                  const SizedBox(width: 5),
                                  const Text('Humidity',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                  const Spacer(),
                                  Text('${weatherData.current.humidity}%',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white70)),
                                ],
                              ),
                            ),
                            const FractionallySizedBox(
                                widthFactor: 0.9,
                                child:
                                    Divider(color: Colors.black, thickness: 1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Last updated:$lastUpdatedDateTime',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
