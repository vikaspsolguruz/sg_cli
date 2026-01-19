import 'package:flutter/material.dart';
import 'package:max_arch/app/app_routes/app_route_config.dart';
import 'package:max_arch/app/app_routes/route_arguments.dart';
import 'package:max_arch/core/utils/bloc/bloc_route_provider.dart';

class AppRoute {
  final AppRouteConfig config;
  final BlocRouteProvider blocProvider;
  final List<AppRoute> subRoutes;

  GlobalKey<NavigatorState>? _navigatorKey;

  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  BuildContext? get context => _navigatorKey?.currentContext;

  RouteArguments? get arguments => config.arguments;

  String get name => config.routeName;

  AppRoute({
    required this.config,
    required this.blocProvider,
    this.subRoutes = const <AppRoute>[],
  }) {
    if (subRoutes.isNotEmpty) {
      _navigatorKey = GlobalKey<NavigatorState>();
    }
  }
}
