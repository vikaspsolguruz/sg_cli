import 'package:sg_cli/utils/name_helper.dart';
import 'package:sg_cli/utils/pubspec_helper.dart';

String generateBlocContent(String pageName) {
  String className = toPascalCase(pageName);
  String variableName = toCamelCase(pageName);
  String moduleName = getModuleName();

  return '''
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:$moduleName/logger/app_logging.dart';
import 'package:$moduleName/utils/analytics_helper.dart';
import 'package:$moduleName/analytics/main_event.dart';

part '${pageName}_event.dart';
part '${pageName}_state.dart';

class ${className}Bloc extends Bloc<${className}Event, ${className}State> with Loggable {
  ${className}Bloc() : super(const ${className}State.initial()) {
    _setupEventListener();
  }
  
  @override
  void onEvent(${className}Event event) {
    super.onEvent(event);
    if (kReleaseMode) return;
    AnalyticsHelper().logCustomEvent(
      event.eventName,
      parameters: event.getAnalyticParameters(),
    );
  }
  
  @override
  String get className => '\$runtimeType';
  
  void _setupEventListener() {}
}

extension ${className}Extension on BuildContext {
  ${className}Bloc get ${variableName}Bloc => BlocProvider.of<${className}Bloc>(this);
}
''';
}

String generateEventContent(String pageName) {
  String className = toPascalCase(pageName);
  return '''
part of '${pageName}_bloc.dart';

abstract class ${className}Event with EquatableMixin implements AnalyticsEvent {
  const ${className}Event();

  @override
  bool shouldLogEvent() => kDebugMode;
}
''';
}

String generateStateContent(String pageName) {
  String className = toPascalCase(pageName);
  return '''
part of '${pageName}_bloc.dart';

class ${className}State extends Equatable {
  const ${className}State();
  
  const ${className}State.initial();
  
  ${className}State copyWith() => ${className}State();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '\$runtimeType';
  
  @visibleForTesting
  const ${className}State.test();
}
''';
}
