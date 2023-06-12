import 'package:auto_route/auto_route.dart';
import 'package:final_app_folder/core/database/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/route/auto_route.gr.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (HiveUtils.fetchWeatherDataFromHive() == null) {
        context.router
            .pushAndPopUntil(const SearchRoute(), predicate: (_) => false);
      } else {
        context.router
            .pushAndPopUntil(const HomeRoute(), predicate: (_) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Weather App ',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SpinKitWaveSpinner(
              color: Colors.green,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
