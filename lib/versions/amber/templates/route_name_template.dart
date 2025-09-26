part of '../amber.dart';

String _generateRouteNameEntry(String pageName) {
  final String constantName = toCamelCase(pageName);
  return "  static const String $constantName = '/$pageName';";
}
