part of '../cyan.dart';

String _generateScreenContent(String pageName) {
  String className = toPascalCase(pageName);
  return '''
import 'package:flutter/material.dart';
$_blocImport
import 'package:$_moduleName/presentation/widgets/common_appbar.dart';

class ${className}Screen extends StatefulWidget {
  const ${className}Screen({super.key});

  @override
  State<${className}Screen> createState() => _${className}State();
}

class _${className}State extends State<${className}Screen> {
  late final bloc = context.${_variableName}Bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: '$className Screen'),
      body: Center(child: Text('Welcome to $className Screen!')),
    );
  }
}
''';
}

String _generateBottomSheetContent(String pageName) {
  String className = toPascalCase(pageName);
  return '''
import 'package:flutter/material.dart';
$_blocImport

class ${className}BottomSheet extends StatefulWidget {
  const ${className}BottomSheet({super.key});

  @override
  State<${className}BottomSheet> createState() => _${className}State();
}

class _${className}State extends State<${className}BottomSheet> {
  late final bloc = context.${_variableName}Bloc;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("$className Bottom Sheet"),
    );
  }
}
''';
}

String _generateDialogContent(String pageName) {
  String className = toPascalCase(pageName);
  return '''
import 'package:flutter/material.dart';
$_blocImport

class ${className}Dialog extends StatefulWidget {
  const ${className}Dialog({super.key});

  @override
  State<${className}Dialog> createState() => _${className}State();
}

class _${className}State extends State<${className}Dialog> {
  late final bloc = context.${_variableName}Bloc;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("$className Dialog"),
    );
  }
}
''';
}
