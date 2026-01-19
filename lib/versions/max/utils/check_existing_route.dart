part of '../max.dart';

bool _checkExistingRoute({String? parentPageName}) {
  // Getting content from route_names.dart file
  final String routeNamesContent = _routeNamesFile.readAsStringSync();
  final String newRouteNameEntry = _generateRouteNameEntry(_pageName,parentPageName: parentPageName);
  return routeNamesContent.contains(newRouteNameEntry);
}
