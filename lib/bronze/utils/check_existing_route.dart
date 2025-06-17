part of '../bronze.dart';

bool _checkExistingRoute() {
  final String routeNamesContent = _routeNamesFile.readAsStringSync();
  final String newRouteNameEntry = _generateRouteNameEntry(_pageName);
  return routeNamesContent.contains(newRouteNameEntry);
}
