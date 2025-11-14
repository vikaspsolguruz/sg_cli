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
$indent    config: const ${className}Route(),
$indent    blocProvider: BlocRouteProvider<${className}Bloc>(
$indent      bloc: (context) => ${className}Bloc(),
$indent      page: const $className${isBottomSheet ? 'BottomSheet' : isDialog ? 'Dialog' : 'Screen'}(),
$indent    ),
$indent  ),''';
}

String _generateRouteConfigEntry(String pageName) {
  final String className = toPascalCase(pageName);
  final String constantName = toCamelCase(pageName);

  return '''
class ${className}Route extends AppRouteConfig<${className}Arguments> {
  const ${className}Route({super.arguments});

  @override
  String get routeName => Routes.$constantName;
}''';
}

// This function is used to generate route arguments for each route
String _generateRouteArgumentsEntry(String pageName) {
  final String className = toPascalCase(pageName);

  return '''
class ${className}Arguments extends RouteArguments {
  const ${className}Arguments();

  static ${className}Arguments? get() => RouteArgumentsProvider.get<${className}Arguments>();
}''';
}
