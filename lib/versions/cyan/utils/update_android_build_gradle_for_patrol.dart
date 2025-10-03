part of '../cyan.dart';

void _updateAndroidBuildGradleForPatrol() {
  // Detect which build file exists
  final buildGradleKts = File('android/app/build.gradle.kts');
  final buildGradle = File('android/app/build.gradle');
  
  if (buildGradleKts.existsSync()) {
    _updateBuildGradleKts(buildGradleKts);
  } else if (buildGradle.existsSync()) {
    _updateBuildGradleGroovy(buildGradle);
  } else {
    print('${ConsoleSymbols.warning}  No build.gradle or build.gradle.kts found');
  }
}

void _updateBuildGradleKts(File buildFile) {
  print('${ConsoleSymbols.loading}  Updating build.gradle.kts for Patrol...');
  
  final content = buildFile.readAsStringSync();
  
  // Check if Patrol config already exists
  if (content.contains('testInstrumentationRunner') && 
      content.contains('PatrolJUnitRunner')) {
    print('${ConsoleSymbols.info}  Patrol configuration already exists in build.gradle.kts');
    return;
  }
  
  // Create backup
  final backupFile = File('${buildFile.path}.backup');
  backupFile.writeAsStringSync(content);
  
  try {
    String updatedContent = content;
    
    // Step 1: Add test runner to defaultConfig
    updatedContent = _addTestRunnerToDefaultConfig(updatedContent, isKotlin: true);
    
    // Step 2: Add testOptions to android block
    updatedContent = _addTestOptions(updatedContent, isKotlin: true);
    
    // Step 3: Add dependencies
    updatedContent = _addTestDependency(updatedContent, isKotlin: true);
    
    // Write updated content
    buildFile.writeAsStringSync(updatedContent);
    
    print('${ConsoleSymbols.success}  Updated build.gradle.kts with Patrol configuration');
    print('${ConsoleSymbols.info}  Backup saved: ${backupFile.path}');
    
    // Clean up backup if successful
    if (backupFile.existsSync()) {
      backupFile.deleteSync();
    }
  } catch (e) {
    print('${ConsoleSymbols.error}  Failed to update build.gradle.kts: $e');
    print('${ConsoleSymbols.info}  Restoring from backup...');
    
    // Restore from backup
    if (backupFile.existsSync()) {
      buildFile.writeAsStringSync(backupFile.readAsStringSync());
      backupFile.deleteSync();
      print('${ConsoleSymbols.success}  Restored original file');
    }
    
    print('${ConsoleSymbols.info}  Please add Patrol configuration manually (see PATROL_ANDROID_SETUP.md)');
  }
}

void _updateBuildGradleGroovy(File buildFile) {
  print('${ConsoleSymbols.loading}  Updating build.gradle for Patrol...');
  
  final content = buildFile.readAsStringSync();
  
  // Check if Patrol config already exists
  if (content.contains('testInstrumentationRunner') && 
      content.contains('PatrolJUnitRunner')) {
    print('${ConsoleSymbols.info}  Patrol configuration already exists in build.gradle');
    return;
  }
  
  // Create backup
  final backupFile = File('${buildFile.path}.backup');
  backupFile.writeAsStringSync(content);
  
  try {
    String updatedContent = content;
    
    // Step 1: Add test runner to defaultConfig
    updatedContent = _addTestRunnerToDefaultConfig(updatedContent, isKotlin: false);
    
    // Step 2: Add testOptions to android block
    updatedContent = _addTestOptions(updatedContent, isKotlin: false);
    
    // Step 3: Add dependencies
    updatedContent = _addTestDependency(updatedContent, isKotlin: false);
    
    // Write updated content
    buildFile.writeAsStringSync(updatedContent);
    
    print('${ConsoleSymbols.success}  Updated build.gradle with Patrol configuration');
    print('${ConsoleSymbols.info}  Backup saved: ${backupFile.path}');
    
    // Clean up backup if successful
    if (backupFile.existsSync()) {
      backupFile.deleteSync();
    }
  } catch (e) {
    print('${ConsoleSymbols.error}  Failed to update build.gradle: $e');
    print('${ConsoleSymbols.info}  Restoring from backup...');
    
    // Restore from backup
    if (backupFile.existsSync()) {
      buildFile.writeAsStringSync(backupFile.readAsStringSync());
      backupFile.deleteSync();
      print('${ConsoleSymbols.success}  Restored original file');
    }
    
    print('${ConsoleSymbols.info}  Please add Patrol configuration manually (see PATROL_ANDROID_SETUP.md)');
  }
}

String _addTestRunnerToDefaultConfig(String content, {required bool isKotlin}) {
  // Find defaultConfig block
  final defaultConfigPattern = RegExp(r'defaultConfig\s*\{');
  final match = defaultConfigPattern.firstMatch(content);
  
  if (match == null) {
    throw Exception('Could not find defaultConfig block');
  }
  
  // Find the closing brace of defaultConfig
  final startIndex = match.end;
  int braceCount = 1;
  int endIndex = startIndex;
  
  for (int i = startIndex; i < content.length; i++) {
    if (content[i] == '{') braceCount++;
    if (content[i] == '}') {
      braceCount--;
      if (braceCount == 0) {
        endIndex = i;
        break;
      }
    }
  }
  
  // Get the defaultConfig content
  final defaultConfigContent = content.substring(startIndex, endIndex);
  
  // Check if testInstrumentationRunner already exists
  if (defaultConfigContent.contains('testInstrumentationRunner')) {
    print('${ConsoleSymbols.info}  testInstrumentationRunner already exists, skipping');
    return content;
  }
  
  // Prepare the lines to add
  final linesToAdd = isKotlin
      ? '\n        testInstrumentationRunner = "pl.leancode.patrol.PatrolJUnitRunner"\n        testInstrumentationRunnerArguments["clearPackageData"] = "true"\n'
      : '\n        testInstrumentationRunner "pl.leancode.patrol.PatrolJUnitRunner"\n        testInstrumentationRunnerArguments clearPackageData: "true"\n';
  
  // Insert before the closing brace
  return content.substring(0, endIndex) + linesToAdd + '    ' + content.substring(endIndex);
}

String _addTestOptions(String content, {required bool isKotlin}) {
  // Check if testOptions already exists
  if (content.contains('testOptions')) {
    print('${ConsoleSymbols.info}  testOptions already exists, skipping');
    return content;
  }
  
  // Find android block
  final androidPattern = RegExp(r'android\s*\{');
  final match = androidPattern.firstMatch(content);
  
  if (match == null) {
    throw Exception('Could not find android block');
  }
  
  // Find a good place to insert testOptions (after buildTypes or flavors)
  final buildTypesPattern = RegExp(r'buildTypes\s*\{[^}]*\}[^}]*\}', multiLine: true, dotAll: true);
  final flavorsPattern = RegExp(r'productFlavors\s*\{[^}]*\}[^}]*\}', multiLine: true, dotAll: true);
  
  int insertIndex = -1;
  
  // Try to insert after productFlavors first
  final flavorsMatch = flavorsPattern.firstMatch(content);
  if (flavorsMatch != null) {
    insertIndex = flavorsMatch.end;
  } else {
    // Otherwise insert after buildTypes
    final buildTypesMatch = buildTypesPattern.firstMatch(content);
    if (buildTypesMatch != null) {
      insertIndex = buildTypesMatch.end;
    }
  }
  
  if (insertIndex == -1) {
    // Fallback: insert after defaultConfig
    final defaultConfigPattern = RegExp(r'defaultConfig\s*\{[^}]*\}[^}]*\}', multiLine: true, dotAll: true);
    final defaultConfigMatch = defaultConfigPattern.firstMatch(content);
    if (defaultConfigMatch != null) {
      insertIndex = defaultConfigMatch.end;
    }
  }
  
  if (insertIndex == -1) {
    throw Exception('Could not find suitable place to insert testOptions');
  }
  
  // Prepare testOptions block
  final testOptionsBlock = isKotlin
      ? '\n\n    testOptions {\n        execution = "ANDROIDX_TEST_ORCHESTRATOR"\n    }\n'
      : '\n\n    testOptions {\n        execution "ANDROIDX_TEST_ORCHESTRATOR"\n    }\n';
  
  return content.substring(0, insertIndex) + testOptionsBlock + content.substring(insertIndex);
}

String _addTestDependency(String content, {required bool isKotlin}) {
  // Check if dependency already exists
  if (content.contains('androidx.test:orchestrator')) {
    print('${ConsoleSymbols.info}  Test orchestrator dependency already exists, skipping');
    return content;
  }
  
  // Find dependencies block
  final dependenciesPattern = RegExp(r'dependencies\s*\{');
  final match = dependenciesPattern.firstMatch(content);
  
  if (match == null) {
    // No dependencies block, add one at the end before closing brace
    final lastBraceIndex = content.lastIndexOf('}');
    final dependencyBlock = isKotlin
        ? '\n\ndependencies {\n    androidTestUtil("androidx.test:orchestrator:1.4.2")\n}\n'
        : '\n\ndependencies {\n    androidTestUtil "androidx.test:orchestrator:1.4.2"\n}\n';
    
    return content.substring(0, lastBraceIndex) + dependencyBlock + content.substring(lastBraceIndex);
  }
  
  // Find the closing brace of dependencies block
  final startIndex = match.end;
  int braceCount = 1;
  int endIndex = startIndex;
  
  for (int i = startIndex; i < content.length; i++) {
    if (content[i] == '{') braceCount++;
    if (content[i] == '}') {
      braceCount--;
      if (braceCount == 0) {
        endIndex = i;
        break;
      }
    }
  }
  
  // Prepare the dependency line
  final dependencyLine = isKotlin
      ? '    androidTestUtil("androidx.test:orchestrator:1.4.2")\n'
      : '    androidTestUtil "androidx.test:orchestrator:1.4.2"\n';
  
  // Insert before the closing brace
  return content.substring(0, endIndex) + dependencyLine + content.substring(endIndex);
}
