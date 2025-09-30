part of '../cyan.dart';


void _addRouteName({String? parentPageName}) {
  // Getting content from route_names.dart file
  final String routeNamesContent = _routeNamesFile.readAsStringSync();
  // splitting into lines from code/content
  final List<String> routeNamesLines = routeNamesContent.split('\n');
  // getting index of closing bracket
  final int classClosingBracketIndex = routeNamesLines.lastIndexWhere((line) => line.trim() == '}');
  // checking if index of closing bracket is not wrong
  if (classClosingBracketIndex == -1) {
    print('${ConsoleSymbols.error}  Error: Could not find closing bracket for Routes class.');
    return;
  }
  // Create line about route name
  final String newRouteNameEntry = _generateRouteNameEntry(_pageName, parentPageName: parentPageName);
  // adding route name in lines
  routeNamesLines.insert(classClosingBracketIndex, newRouteNameEntry);
  // inserting lines into file
  _routeNamesFile.writeAsStringSync(routeNamesLines.join('\n'));

  print('${ConsoleSymbols.success}  Route and route name added successfully.');
}
