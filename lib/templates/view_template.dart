import '../utils/name_helper.dart';

String generateViewContent(String pageName) {
  String className = toPascalCase(pageName);
  return '''
import 'package:flutter/material.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$className Page')),
      body: Center(child: Text('Welcome to $className Page!')),
    );
  }
}
''';
}
