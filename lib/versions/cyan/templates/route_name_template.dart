part of '../cyan.dart';

String _generateRouteNameEntry(String pageName, {String? parentPageName}) {
  final String constantName = toCamelCase(pageName);
  String path;
  if (parentPageName != null) {
    path = "$parentPageName/$pageName";
  } else {
    path = "/$pageName";
  }

  return "  static const String $constantName = '$path';";
}
