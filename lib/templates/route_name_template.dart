import 'package:sg_cli/utils/name_helper.dart';

String generateRouteNameEntry(String pageName) {
  final String constantName = toCamelCase(pageName);
  return "  static const String $constantName = '/$pageName';";
}
