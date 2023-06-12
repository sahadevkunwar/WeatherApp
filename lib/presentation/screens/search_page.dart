import 'package:auto_route/auto_route.dart';
import 'package:final_app_folder/presentation/cubit/weather_cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/route/auto_route.gr.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late final WeatherCubit weatherCubit;

  @override
  void initState() {
    super.initState();
    weatherCubit = context.read<WeatherCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Weather',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final String dataFromUI = _searchController.text;
                  weatherCubit.searchWeather(queryFromUI: dataFromUI);
                  context.router.pushAndPopUntil(const HomeRoute(),
                      predicate: (_) => false);
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
