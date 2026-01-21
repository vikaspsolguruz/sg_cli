part of '../amber.dart';

bool _prepareRouteData() {
  _routesFilePath = 'lib/app_routes/routes.dart';
  _routeNamesFilePath = 'lib/app_routes/route_names.dart';

  _routesFile = File(_routesFilePath);
  _routeNamesFile = File(_routeNamesFilePath);
  if (!_routesFile.existsSync()) {
    ConsoleLogger.error('Routes file not found: $_routesFilePath');
    return false;
  }

  if (!_routeNamesFile.existsSync()) {
    ConsoleLogger.error('Route names file not found: $_routeNamesFilePath');
    return false;
  }
  return true;
}
