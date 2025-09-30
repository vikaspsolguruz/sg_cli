part of '../cyan.dart';

/// Modifies app.dart to add deep link initialization
void modifyAppForDeepLink(String projectName) {
  final appFile = File('lib/app/app.dart');
  
  if (!appFile.existsSync()) {
    print('${ConsoleSymbols.error}app.dart not found at lib/app/app.dart');
    return;
  }

  String content = appFile.readAsStringSync();

  // Check if deep link is already added
  if (content.contains('DeepLinkManager.instance.initialize()')) {
    print('${ConsoleSymbols.info}Deep link already configured in app.dart');
    return;
  }

  // Add import at the top (after other imports)
  final importLine = "import 'package:$projectName/core/utils/deep_link_manager.dart';";
  
  if (!content.contains(importLine)) {
    // Find the last import and add after it
    final importRegex = RegExp(r"import '[^']+';");
    final matches = importRegex.allMatches(content);
    
    if (matches.isNotEmpty) {
      final lastImport = matches.last;
      final insertPosition = lastImport.end;
      content = content.substring(0, insertPosition) + 
                '\n$importLine' + 
                content.substring(insertPosition);
    }
  }

  // Add initialization in initState
  if (content.contains('@override\n  void initState()')) {
    // Find initState and add initialization after super.initState() or at the beginning
    final initStateRegex = RegExp(
      r'@override\s+void initState\(\)\s*\{([^}]*)\}',
      multiLine: true,
      dotAll: true,
    );
    
    final match = initStateRegex.firstMatch(content);
    if (match != null) {
      final initStateBody = match.group(1) ?? '';
      
      // Check if super.initState() exists
      if (initStateBody.contains('super.initState()')) {
        // Add before super.initState()
        final modifiedBody = initStateBody.replaceFirst(
          'super.initState()',
          'DeepLinkManager.instance.initialize();\n    super.initState()',
        );
        content = content.replaceFirst(initStateRegex, '@override\n  void initState() {$modifiedBody}');
      } else {
        // Add at the beginning of initState
        final lines = initStateBody.split('\n');
        final firstNonEmptyIndex = lines.indexWhere((line) => line.trim().isNotEmpty);
        
        if (firstNonEmptyIndex != -1) {
          lines.insert(firstNonEmptyIndex, '    DeepLinkManager.instance.initialize();');
          final modifiedBody = lines.join('\n');
          content = content.replaceFirst(initStateRegex, '@override\n  void initState() {$modifiedBody}');
        }
      }
    }
  }

  // Add dispose in dispose method
  if (content.contains('@override\n  void dispose()')) {
    final disposeRegex = RegExp(
      r'@override\s+void dispose\(\)\s*\{([^}]*)\}',
      multiLine: true,
      dotAll: true,
    );
    
    final match = disposeRegex.firstMatch(content);
    if (match != null) {
      final disposeBody = match.group(1) ?? '';
      
      // Check if super.dispose() exists
      if (disposeBody.contains('super.dispose()')) {
        // Add before super.dispose()
        final modifiedBody = disposeBody.replaceFirst(
          'super.dispose()',
          'DeepLinkManager.instance.dispose();\n    super.dispose()',
        );
        content = content.replaceFirst(disposeRegex, '@override\n  void dispose() {$modifiedBody}');
      } else {
        // Add at the end of dispose
        final modifiedBody = '$disposeBody    DeepLinkManager.instance.dispose();\n';
        content = content.replaceFirst(disposeRegex, '@override\n  void dispose() {$modifiedBody}');
      }
    }
  }

  // Write modified content
  appFile.writeAsStringSync(content);
  print('${ConsoleSymbols.success}Added deep link initialization to app.dart');
}
