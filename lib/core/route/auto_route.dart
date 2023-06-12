import 'package:auto_route/auto_route.dart';

import 'auto_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SearchRoute.page, path: '/searchWeather'),
    AutoRoute(page: HomeRoute.page, path: '/homePage'),
    AutoRoute(page: SplashRoute.page, path: '/'),
  ];
}
