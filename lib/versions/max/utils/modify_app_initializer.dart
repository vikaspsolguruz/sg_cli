part of '../max.dart';

/// Injects Firebase initialization code into _app_initializer.dart
void _injectFirebaseInitialization(String projectName, bool hasFlavors) {
  final appInitializerFile = File('lib/_app_initializer.dart');
  
  if (!appInitializerFile.existsSync()) {
    print('${ConsoleSymbols.warning}  lib/_app_initializer.dart not found, skipping code injection...');
    return;
  }
  
  var content = appInitializerFile.readAsStringSync();
  
  // Check if Firebase initialization already exists
  if (content.contains('Firebase.initializeApp')) {
    print('${ConsoleSymbols.info}  Firebase initialization already exists in _app_initializer.dart');
    return;
  }
  
  // Find the initializeApp() function and inject Firebase code
  final initFunctionPattern = RegExp(
    r'Future<void>\s+initializeApp\(\)\s+async\s*\{',
    multiLine: true,
  );
  
  final match = initFunctionPattern.firstMatch(content);
  if (match == null) {
    print('${ConsoleSymbols.warning}  Could not find initializeApp() function in _app_initializer.dart');
    return;
  }
  
  // Get Firebase initialization code
  final firebaseInitCode = hasFlavors 
    ? _firebaseInitCodeFlavoredTemplate(projectName)
    : _firebaseInitCodeSingleTemplate();
  
  // Find position to inject (after WidgetsFlutterBinding.ensureInitialized())
  final ensureInitializedPattern = RegExp(
    r'WidgetsFlutterBinding\.ensureInitialized\(\);',
  );
  
  final ensureMatch = ensureInitializedPattern.firstMatch(content);
  
  if (ensureMatch != null) {
    // Insert after WidgetsFlutterBinding.ensureInitialized();
    final insertPosition = ensureMatch.end;
    content = content.substring(0, insertPosition) + 
              firebaseInitCode + 
              content.substring(insertPosition);
  } else {
    // Insert at the beginning of initializeApp function
    final insertPosition = match.end;
    content = content.substring(0, insertPosition) + 
              '\n    WidgetsFlutterBinding.ensureInitialized();' +
              firebaseInitCode + 
              content.substring(insertPosition);
  }
  
  appInitializerFile.writeAsStringSync(content);
  print('${ConsoleSymbols.checkmark} Injected Firebase initialization code into _app_initializer.dart');
  
  // Add required imports
  List<String> imports = [
    "import 'package:firebase_core/firebase_core.dart';",
  ];
  
  if (hasFlavors) {
    imports.addAll([
      "import 'package:$projectName/environments/environments.dart';",
      "import 'package:$projectName/firebase_options_dev.dart' as dev;",
      "import 'package:$projectName/firebase_options_stage.dart' as stage;",
      "import 'package:$projectName/firebase_options_prod.dart' as prod;",
    ]);
  } else {
    imports.add("import 'firebase_options.dart';");
  }
  
  _addImportsToFile(appInitializerFile, imports);
}
