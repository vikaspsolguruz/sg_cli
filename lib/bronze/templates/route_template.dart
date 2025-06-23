part of '../bronze.dart';

String _generateRouteEntry(String pageName, {bool isIndented = false}) {
  final String className = toPascalCase(pageName);
  final String constantName = toCamelCase(pageName);
  final indent = isIndented ? '        ' : '    ';

  return '''$indent  AppRoute(
$indent    name: Routes.$constantName,
$indent    blocProvider: BlocPageProvider<${className}Bloc>(
$indent      bloc: (context) => ${className}Bloc(),
$indent      page: const ${className}Screen(),
$indent    ),
$indent  ),''';
}
