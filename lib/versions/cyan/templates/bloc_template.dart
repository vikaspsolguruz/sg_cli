part of '../cyan.dart';

String _generateBlocContent(String pageName) {
  String className = toPascalCase(pageName);
  _variableName = toCamelCase(pageName);
  String moduleName = getModuleName();

  return '''
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$moduleName/core/utils/bloc/base_bloc.dart';
import 'package:$moduleName/core/utils/bloc/bloc_event.dart';

part '${pageName}_event.dart';
part '${pageName}_state.dart';

class ${className}Bloc extends BaseBloc<${className}Event, ${className}State> {
  ${className}Bloc() : super(const ${className}State.initial());
  
  @override
  void eventListeners() {}
}

extension ${className}Extension on BuildContext {
  ${className}Bloc get ${_variableName}Bloc => BlocProvider.of<${className}Bloc>(this);
}
''';
}

String _generateEventContent(String pageName) {
  String className = toPascalCase(pageName);
  return '''
part of '${pageName}_bloc.dart';

abstract class ${className}Event extends BlocEvent {
  const ${className}Event();
}
''';
}

String _generateStateContent(String pageName) {
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
