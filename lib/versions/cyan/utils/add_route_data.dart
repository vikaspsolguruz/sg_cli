part of '../cyan.dart';

void _addRouteData({bool isBottomSheet = false, bool isDialog = false}) {
  // Create line about builder and route with bloc provider
  final String newRouteEntry = _generateRouteEntry(_pageName,isBottomSheet: isBottomSheet, isDialog: isDialog);

  // getting content of app/app_routes file
  final String routesContent = _routesFile.readAsStringSync();
  // getting lines of app/app_routes
  final List<String> routesLines = routesContent.split('\n');

  // getting index of last import
  final int lastImportIndex = routesLines.lastIndexWhere((line) => line.startsWith('import '));

  // Prepare all imports that need to be added
  final String configImport = "import 'package:$_moduleName/app/app_routes/app_route_config.dart';";
  final String blocProviderImport = "import 'package:$_moduleName/core/utils/bloc/bloc_route_provider.dart';";

  // Add imports in order if they don't exist
  int currentInsertIndex = lastImportIndex + 1;

  if (!routesLines.contains(configImport)) {
    routesLines.insert(currentInsertIndex, configImport);
    currentInsertIndex++;
  }

  if (!routesLines.contains(blocProviderImport)) {
    routesLines.insert(currentInsertIndex, blocProviderImport);
    currentInsertIndex++;
  }

  if (!routesLines.contains(_blocImport)) {
    routesLines.insert(currentInsertIndex, _blocImport);
    currentInsertIndex++;
  }

  if (!routesLines.contains(_viewImport)) {
    routesLines.insert(currentInsertIndex, _viewImport);
    currentInsertIndex++;
  }

  // getting index of closing bracket for appRoutes
  final int closingBracketIndex = routesLines.lastIndexWhere((line) => line.trim() == '];');

  // checking if index of closing bracket is not wrong
  if (closingBracketIndex == -1) {
    print('${ConsoleSymbols.error}  Error: Could not find closing bracket for the routes.');
    return;
  }

  // Find the comment line for the route type (e.g., "// Screen Routes")
  final String routeTypeComment = isBottomSheet
      ? '      // Bottom Sheet Routes'
      : isDialog
      ? '      // Dialog Routes'
      : '      // Screen Routes';

  int insertIndex = closingBracketIndex;

  // Look for the comment line to insert after it
  for (int i = 0; i < routesLines.length; i++) {
    if (routesLines[i].trim() == routeTypeComment.trim()) {
      insertIndex = i + 1;
      break;
    }
  }

  // adding route data in lines
  routesLines.insert(insertIndex, newRouteEntry);
  // inserting lines into appRoutes file
  _routesFile.writeAsStringSync(routesLines.join('\n'));

  // Add route config and arguments
  _addRouteConfig();
  _addRouteArguments();
}

void _addRouteConfig() {
  final String configFilePath = 'lib/app/app_routes/app_route_config.dart';
  final File configFile = File(configFilePath);

  if (!configFile.existsSync()) {
    print('${ConsoleSymbols.error}  Error: Route config file not found: $configFilePath');
    return;
  }

  final String configContent = configFile.readAsStringSync();
  final List<String> configLines = configContent.split('\n');

  final String newConfigEntry = _generateRouteConfigEntry(_pageName);

  // Check if config already exists
  final String className = toPascalCase(_pageName);
  if (configContent.contains('class ${className}Route extends')) {
    return; // Already exists
  }

  // Ensure necessary imports are present
  if (!configContent.contains("import 'package:$_moduleName/app/app_routes/_route_names.dart';")) {
    final int lastImportIndex = configLines.lastIndexWhere((line) => line.startsWith('import '));
    if (lastImportIndex != -1) {
      configLines.insert(lastImportIndex + 1, "import 'package:$_moduleName/app/app_routes/_route_names.dart';");
    }
  }

  if (!configContent.contains("import 'package:$_moduleName/app/app_routes/route_arguments.dart';")) {
    final int lastImportIndex = configLines.lastIndexWhere((line) => line.startsWith('import '));
    if (lastImportIndex != -1) {
      configLines.insert(lastImportIndex + 1, "import 'package:$_moduleName/app/app_routes/route_arguments.dart';");
    }
  }

  // Add at the end of the file
  configLines.add(newConfigEntry);
  configFile.writeAsStringSync(configLines.join('\n'));
}

void _addRouteArguments() {
  final String argsFilePath = 'lib/app/app_routes/route_arguments.dart';
  final File argsFile = File(argsFilePath);

  if (!argsFile.existsSync()) {
    print('${ConsoleSymbols.error}  Error: Route arguments file not found: $argsFilePath');
    return;
  }

  final String argsContent = argsFile.readAsStringSync();
  final List<String> argsLines = argsContent.split('\n');

  final String newArgsEntry = _generateRouteArgumentsEntry(_pageName);

  // Check if arguments class already exists
  final String className = toPascalCase(_pageName);
  if (argsContent.contains('class ${className}Arguments extends')) {
    return; // Already exists
  }

  // Add at the end of the file
  argsLines.add(newArgsEntry);
  argsFile.writeAsStringSync(argsLines.join('\n'));
}

void _addSubRouteData({required String subPageName, required String parentPageName}) {
  final String subRouteEntry = _generateRouteEntry(subPageName, isIndented: true);
  final String routesContent = _routesFile.readAsStringSync();
  final List<String> routesLines = routesContent.split('\n');

  // getting index of last import
  final int lastImportIndex = routesLines.lastIndexWhere((line) => line.startsWith('import '));

  // Prepare all imports that need to be added
  final String configImport = "import 'package:$_moduleName/app/app_routes/app_route_config.dart';";
  final String blocProviderImport = "import 'package:$_moduleName/core/utils/bloc/bloc_route_provider.dart';";

  // Add imports in order if they don't exist
  int currentInsertIndex = lastImportIndex + 1;

  if (!routesLines.contains(configImport)) {
    routesLines.insert(currentInsertIndex, configImport);
    currentInsertIndex++;
  }

  if (!routesLines.contains(blocProviderImport)) {
    routesLines.insert(currentInsertIndex, blocProviderImport);
    currentInsertIndex++;
  }

  if (!routesLines.contains(_blocImport)) {
    routesLines.insert(currentInsertIndex, _blocImport);
    currentInsertIndex++;
  }

  if (!routesLines.contains(_viewImport)) {
    routesLines.insert(currentInsertIndex, _viewImport);
    currentInsertIndex++;
  }

  // 1. Locate AppRoute with config: const <ParentPage>Route()
  int configIndex = routesLines.indexWhere((line) => line.contains('config: const ${toPascalCase(parentPageName)}Route()'));
  if (configIndex == -1) {
    print('${ConsoleSymbols.error} Could not find parent route: $parentPageName');
    return;
  }

  // 2. Walk upward to find AppRoute(...) line
  int routeStartIndex = configIndex;
  while (!routesLines[routeStartIndex].contains('AppRoute(')) {
    routeStartIndex--;
    if (routeStartIndex < 0) {
      print('${ConsoleSymbols.error} Failed to find AppRoute() start.');
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
    print('${ConsoleSymbols.error} Could not find end of AppRoute block.');
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
      print('${ConsoleSymbols.error} Malformed subRoutes block.');
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
      print('${ConsoleSymbols.error} Could not find blocProvider block to insert subRoutes.');
    }
  }

  _routesFile.writeAsStringSync(routesLines.join('\n'));

  // Add route config and arguments for sub-route
  String originalPageName = _pageName;
  _pageName = subPageName;
  _addRouteConfig();
  _addRouteArguments();
  _pageName = originalPageName;
}

int _countChar(String line, String char) => line.split('').where((c) => c == char).length;
