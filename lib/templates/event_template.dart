import 'package:sg_cli/utils/name_helper.dart';

String generateEventContent(String eventName, String pageName) {
  final String className = toPascalCase(eventName);
  final String pageClassName = toPascalCase(pageName);

  return '''


class $className extends ${pageClassName}Event {
  const $className();

  @override
  Map<String, String>? getAnalyticParameters() => {};
  
  @override
  String get eventName => '\$runtimeType';
  
  @override
  List<Object?> get props => [];
}
''';
}
