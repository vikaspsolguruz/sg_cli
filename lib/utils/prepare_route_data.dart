import 'dart:io';

import 'package:sg_cli/data/global_vars.dart';

bool prepareRouteData() {
  routesFilePath = 'lib/app_routes/routes.dart';
  routeNamesFilePath = 'lib/app_routes/route_names.dart';

  routesFile = File(routesFilePath);
  routeNamesFile = File(routeNamesFilePath);
  if (!routesFile.existsSync()) {
    print('❌  Error: Routes file not found: $routesFilePath');
    return false;
  }

  if (!routeNamesFile.existsSync()) {
    print('❌  Error: Route names file not found: $routeNamesFilePath');
    return false;
  }
  return true;
}