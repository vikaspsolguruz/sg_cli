part of '../../amber.dart';

void addRouteData() {
  // Create line about builder and route with bloc provider
  final String newRouteEntry = _generateRouteEntry(_pageName);

  // getting content of app_routes file
  final String routesContent = _routesFile.readAsStringSync();
  // getting lines of app_routes
  final List<String> routesLines = routesContent.split('\n');

  // getting index of last import
  final int lastImportIndex = routesLines.lastIndexWhere((line) => line.startsWith('import '));

  // check if view import already exists
  if (!routesLines.contains(_viewImport)) {
    routesLines.insert(lastImportIndex + 1, _viewImport);
  }

  // check if bloc import already exists
  if (!routesLines.contains(_blocImport)) {
    routesLines.insert(lastImportIndex + 1, _blocImport);
  }

  // getting index of closing bracket for appRoutes
  final int closingBracketIndex = routesLines.lastIndexWhere((line) => line.trim() == '};');

  // checking if index of closing bracket is not wrong
  if (closingBracketIndex == -1) {
    print('❌  Error: Could not find closing bracket for appRoutes.');
    return;
  }

  // adding route data in lines
  routesLines.insert(closingBracketIndex, newRouteEntry);
  // inserting lines into appRoutes file
  _routesFile.writeAsStringSync(routesLines.join('\n'));
}

void addRouteName() {
  // Getting content from route_names.dart file
  final String routeNamesContent = _routeNamesFile.readAsStringSync();
  // splitting into lines from code/content
  final List<String> routeNamesLines = routeNamesContent.split('\n');
  // getting index of closing bracket
  final int classClosingBracketIndex = routeNamesLines.lastIndexWhere((line) => line.trim() == '}');
  // checking if index of closing bracket is not wrong
  if (classClosingBracketIndex == -1) {
    print('❌  Error: Could not find closing bracket for Routes class.');
    return;
  }
  // Create line about route name
  final String newRouteNameEntry = _generateRouteNameEntry(_pageName);
  // adding route name in lines
  routeNamesLines.insert(classClosingBracketIndex, newRouteNameEntry);
  // inserting lines into file
  _routeNamesFile.writeAsStringSync(routeNamesLines.join('\n'));

  print('✅  Route and route name added successfully.');
}
