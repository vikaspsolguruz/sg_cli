import 'package:sg_cli/utils/name_helper.dart';

String generateRouteEntry(String pageName) {
  final String className = toPascalCase(pageName);
  final String constantName = toCamelCase(pageName);

  return '''
  Routes.$constantName: (context) => BlocProvider<${className}Bloc>(
        create: (context) => ${className}Bloc(),
        lazy: false,
        child: const ${className}Page(),
      ),''';
}
