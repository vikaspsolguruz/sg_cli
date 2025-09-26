part of '../cyan.dart';

String generateEventContent(String eventName, String pageName) {
  final String className = toPascalCase(eventName);
  final String pageClassName = toPascalCase(pageName);

  return '''


class $className extends ${pageClassName}Event {
  const $className();

  @override
  Map<String, dynamic> getAnalyticParameters() => {};
  
  @override
  List<Object?> get props => [];
}
''';
}
