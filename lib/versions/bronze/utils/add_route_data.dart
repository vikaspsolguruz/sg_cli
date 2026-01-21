part of '../bronze.dart';

void _addRouteData({bool isBottomSheet = false, bool isDialog = false}) {
  // Create line about builder and route with bloc provider
  final String newRouteEntry = _generateRouteEntry(_pageName,isBottomSheet: isBottomSheet, isDialog: isDialog);

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
  final int closingBracketIndex = routesLines.lastIndexWhere((line) => line.trim() == '];');

  // checking if index of closing bracket is not wrong
  if (closingBracketIndex == -1) {
    ConsoleLogger.error("Could not find parent route: ");
    return;
  }

  // adding route data in lines
  routesLines.insert(closingBracketIndex, newRouteEntry);
  // inserting lines into appRoutes file
  _routesFile.writeAsStringSync(routesLines.join('\n'));
}

void _addSubRouteData({required String subPageName, required String parentPageName}) {
  final String subRouteEntry = _generateRouteEntry(subPageName, isIndented: true);
  final String routesContent = _routesFile.readAsStringSync();
  final List<String> routesLines = routesContent.split('\n');

  final int lastImportIndex = routesLines.lastIndexWhere((line) => line.startsWith('import '));

  if (!routesLines.contains(_viewImport)) {
    routesLines.insert(lastImportIndex + 1, _viewImport);
  }

  if (!routesLines.contains(_blocImport)) {
    routesLines.insert(lastImportIndex + 1, _blocImport);
  }

  // 1. Locate AppRoute with name: Routes.<parentPageName>
  int nameIndex = routesLines.indexWhere((line) => line.contains('name: Routes.$parentPageName'));
  if (nameIndex == -1) {
ConsoleLogger.error("Could not find parent route: ");
    return;
  }

  // 2. Walk upward to find AppRoute(...) line
  int routeStartIndex = nameIndex;
  while (!routesLines[routeStartIndex].contains('AppRoute(')) {
    routeStartIndex--;
    if (routeStartIndex < 0) {
ConsoleLogger.error("Failed to find AppRoute() start.");
      return;
    }
  }

  // 3. Walk downward to find where AppRoute ends
  int bracketDepth = 0;
  int routeEndIndex = -1;
  for (int i = routeStartIndex; i < routesLines.length; i++) {
    bracketDepth += _countChar(routesLines[i], '(');
    bracketDepth -= _countChar(routesLines[i], ')');

    if (bracketDepth <= 0 && routesLines[i].trim().endsWith('),')) {
      routeEndIndex = i;
      break;
    }
  }

  if (routeEndIndex == -1) {
    ConsoleLogger.error('Could not find end of AppRoute block.');
    return;
  }

  // 4. Check if subRoutes already exists
  int subRoutesIndex = -1;
  for (int i = routeStartIndex; i <= routeEndIndex; i++) {
    if (routesLines[i].trim().startsWith('subRoutes: [')) {
      subRoutesIndex = i;
      break;
    }
  }

  if (subRoutesIndex != -1) {
    // subRoutes exists — insert before the closing ],
    final int closingIndex = routesLines.indexWhere((line) => line.trim() == '],', subRoutesIndex);
    if (closingIndex != -1) {
      routesLines.insert(closingIndex, subRouteEntry);
    } else {
      ConsoleLogger.error('Malformed subRoutes block.');
    }
  } else {
    // 5. Find end of blocProvider
    int blocEndIndex = -1;
    for (int i = routeStartIndex; i < routeEndIndex; i++) {
      if (routesLines[i].trim().startsWith('blocProvider:')) {
        int depth = 0;
        for (int j = i; j <= routeEndIndex; j++) {
          depth += _countChar(routesLines[j], '(');
          depth -= _countChar(routesLines[j], ')');
          if (depth == 0) {
            blocEndIndex = j;
            break;
          }
        }
        break;
      }
    }

    if (blocEndIndex != -1) {
      final subRoutesBlock = '''
        subRoutes: [
$subRouteEntry
        ],''';
      routesLines.insert(blocEndIndex + 1, subRoutesBlock);
    } else {
      ConsoleLogger.error('Could not find blocProvider block to insert subRoutes.');
    }
  }

  _routesFile.writeAsStringSync(routesLines.join('\n'));
}

int _countChar(String line, String char) => line.split('').where((c) => c == char).length;
