part of '../cyan.dart';

String _generateRouteEntry(
  String pageName, {
  bool isIndented = false,
  bool isBottomSheet = false,
  bool isDialog = false,
}) {
  final String className = toPascalCase(pageName);
  final String constantName = toCamelCase(pageName);
  final indent = isIndented ? '        ' : '    ';

  return '''$indent  AppRoute(
$indent    name: Routes.$constantName,
$indent    blocProvider: BlocPageProvider<${className}Bloc>(
$indent      bloc: (context) => ${className}Bloc(),
$indent      page: const $className${isBottomSheet ? 'BottomSheet' : isDialog ? 'Dialog' : 'Screen'}(),
$indent    ),
$indent  ),''';
}
