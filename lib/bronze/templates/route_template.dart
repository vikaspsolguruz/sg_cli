part of '../bronze.dart';

String _generateRouteEntry(String pageName) {
  final String className = toPascalCase(pageName);
  final String constantName = toCamelCase(pageName);

  return '''
      AppRoute(
        name: Routes.$constantName,
        blocProvider: BlocPageProvider<${className}Bloc>(
          bloc: (context) => ${className}Bloc(),
          page: const ${className}Screen(),
        ),
      ),''';
}
