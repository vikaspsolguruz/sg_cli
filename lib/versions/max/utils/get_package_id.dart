part of '../max.dart';

String _getBasePackageId() {
  // Try Kotlin DSL first
  final buildGradleKts = File('android/app/build.gradle.kts');
  if (buildGradleKts.existsSync()) {
    final content = buildGradleKts.readAsStringSync();
    
    // Try namespace first (newer Android)
    var match = RegExp(r'namespace\s*=\s*"([^"]+)"').firstMatch(content);
    if (match != null) {
      return match.group(1)!;
    }
    
    // Fallback to applicationId
    match = RegExp(r'applicationId\s*=\s*"([^"]+)"').firstMatch(content);
    if (match != null) {
      return match.group(1)!;
    }
  }
  
  // Try Groovy DSL
  final buildGradle = File('android/app/build.gradle');
  if (buildGradle.existsSync()) {
    final content = buildGradle.readAsStringSync();
    
    // Try namespace with double quotes
    var match = RegExp(r'namespace\s+"([^"]+)"').firstMatch(content);
    if (match != null) {
      return match.group(1)!;
    }
    
    // Try namespace with single quotes
    match = RegExp(r"namespace\s+'([^']+)'").firstMatch(content);
    if (match != null) {
      return match.group(1)!;
    }
    
    // Try applicationId with double quotes
    match = RegExp(r'applicationId\s+"([^"]+)"').firstMatch(content);
    if (match != null) {
      return match.group(1)!;
    }
    
    // Try applicationId with single quotes
    match = RegExp(r"applicationId\s+'([^']+)'").firstMatch(content);
    if (match != null) {
      return match.group(1)!;
    }
  }
  
  print('${ConsoleSymbols.warning}  Could not find package ID in build.gradle files, using default');
  return 'com.example.app';
}
