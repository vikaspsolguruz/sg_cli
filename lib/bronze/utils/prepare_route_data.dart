part of '../bronze.dart';

bool _prepareRouteData() {
  _routesFilePath = 'lib/app_routes/screen_routes.dart';
  _routeNamesFilePath = 'lib/app_routes/_route_names.dart';

  _routesFile = File(_routesFilePath);
  _routeNamesFile = File(_routeNamesFilePath);
  if (!_routesFile.existsSync()) {
    print('❌  Error: Routes file not found: $_routesFilePath');
    return false;
  }

  if (!_routeNamesFile.existsSync()) {
    print('❌  Error: Route names file not found: $_routeNamesFilePath');
    return false;
  }
  return true;
}
