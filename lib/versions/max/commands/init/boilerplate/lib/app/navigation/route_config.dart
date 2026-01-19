import 'package:flutter/material.dart';
import 'package:max_arch/app/navigation/app_route.dart';

abstract class RouteConfig {
  List<AppRoute> routes();

  Map<String, Widget Function(BuildContext)> routesMap() {
    final Map<String, Widget Function(BuildContext)> map = {};
    for (AppRoute route in routes()) {
      map[route.name] = (context) => route.blocProvider.build(context);
    }
    return map;
  }
}
