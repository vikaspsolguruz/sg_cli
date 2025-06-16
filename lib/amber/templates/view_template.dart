part of '../amber.dart';

String _generateViewContent(String pageName) {
  String className = toPascalCase(pageName);
  return '''
import 'package:flutter/material.dart';
$_blocImport
import 'package:$_moduleName/widgets/common_appbar.dart';

class ${className}Page extends StatefulWidget {
  const ${className}Page({super.key});

  @override
  State<${className}Page> createState() => _${className}State();
}

class _${className}State extends State<${className}Page> {
  late final bloc = context.${_variableName}Bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: '$className Page'),
      body: Center(child: Text('Welcome to $className Page!')),
    );
  }
}
''';
}
