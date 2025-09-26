import 'package:flutter/material.dart';
import 'package:newarch/core/utils/bloc/bloc_route_provider.dart';
import 'package:newarch/core/utils/extensions.dart';

class AppRoute {
  final String name;
  final BlocRouteProvider blocProvider;
  final List<AppRoute> subRoutes;

  GlobalKey<NavigatorState>? _navigatorKey;

  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  BuildContext? get context => _navigatorKey?.currentContext;

  Map<String, dynamic>? get arguments => _navigatorKey?.currentContext?.arguments;

  AppRoute({
    required this.name,
    required this.blocProvider,
    this.subRoutes = const <AppRoute>[],
  }) {
    if (subRoutes.isNotEmpty) {
      _navigatorKey = GlobalKey<NavigatorState>();
    }
  }
}
