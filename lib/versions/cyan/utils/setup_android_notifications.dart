part of '../cyan.dart';

void _setupAndroidNotifications() {
  print('📱 Configuring Android for FCM and local notifications...');
  
  try {
    _updateAndroidBuildGradle();
    _updateAndroidManifest();
    _addAndroidProguardRules();
    print('${ConsoleSymbols.success}  Android notification support configured');
  } catch (e) {
    print('${ConsoleSymbols.warning}  Failed to configure Android notifications: $e');
  }
}

void _updateAndroidBuildGradle() {
  final buildGradleFile = File('android/app/build.gradle.kts');
  
  if (!buildGradleFile.existsSync()) {
    // Try build.gradle instead
    final buildGradleGroovyFile = File('android/app/build.gradle');
    if (!buildGradleGroovyFile.existsSync()) {
      throw Exception('Android build.gradle file not found');
    }
    _updateAndroidBuildGradleGroovy(buildGradleGroovyFile);
    return;
  }
  
  final content = buildGradleFile.readAsStringSync();
  
  // Check if desugar is already configured
  if (content.contains('isCoreLibraryDesugaringEnabled') && content.contains('desugar_jdk_libs')) {
    print('${ConsoleSymbols.success}  Android desugar already configured');
    return;
  }
  
  String updatedContent = content;
  
  // Add desugar to compileOptions if not present
  if (!content.contains('isCoreLibraryDesugaringEnabled')) {
    final compileOptionsRegex = RegExp(r'compileOptions\s*\{[^}]*\}', multiLine: true, dotAll: true);
    final match = compileOptionsRegex.firstMatch(updatedContent);
    if (match != null) {
      final compileOptions = match.group(0)!;
      if (!compileOptions.contains('isCoreLibraryDesugaringEnabled')) {
        final newCompileOptions = compileOptions.replaceFirst(
          '{',
          '{\n        // Enable desugaring for Java 8+ APIs (required for local notifications)\n        isCoreLibraryDesugaringEnabled = true'
        );
        updatedContent = updatedContent.replaceFirst(compileOptions, newCompileOptions);
      }
    }
  }
  
  // Add desugar dependency if not present
  if (!content.contains('desugar_jdk_libs')) {
    if (content.contains('dependencies {')) {
      updatedContent = updatedContent.replaceFirst(
        'dependencies {',
        'dependencies {\n    // Core library desugaring for Java 8+ APIs (required for local notifications)\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")'
      );
    } else {
      // Add dependencies section at the end if it doesn't exist
      updatedContent += '''

dependencies {
    // Core library desugaring for Java 8+ APIs (required for local notifications)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
''';
    }
  }
  
  if (content != updatedContent) {
    buildGradleFile.writeAsStringSync(updatedContent);
    print('${ConsoleSymbols.success}  Added desugar dependency to build.gradle.kts');
  }
}

void _updateAndroidBuildGradleGroovy(File buildGradleFile) {
  final content = buildGradleFile.readAsStringSync();
  
  // Check if desugar is already configured
  if (content.contains('coreLibraryDesugaringEnabled') && content.contains('desugar_jdk_libs')) {
    print('${ConsoleSymbols.success}  Android desugar already configured');
    return;
  }
  
  String updatedContent = content;
  
  // Add desugar to compileOptions if not present
  if (!content.contains('coreLibraryDesugaringEnabled')) {
    final compileOptionsRegex = RegExp(r'compileOptions\s*\{[^}]*\}', multiLine: true, dotAll: true);
    final match = compileOptionsRegex.firstMatch(updatedContent);
    if (match != null) {
      final compileOptions = match.group(0)!;
      if (!compileOptions.contains('coreLibraryDesugaringEnabled')) {
        final newCompileOptions = compileOptions.replaceFirst(
          '{',
          '{\n        // Enable desugaring for Java 8+ APIs (required for local notifications)\n        coreLibraryDesugaringEnabled true'
        );
        updatedContent = updatedContent.replaceFirst(compileOptions, newCompileOptions);
      }
    }
  }
  
  // Add desugar dependency if not present
  if (!content.contains('desugar_jdk_libs')) {
    if (content.contains('dependencies {')) {
      updatedContent = updatedContent.replaceFirst(
        'dependencies {',
        'dependencies {\n    // Core library desugaring for Java 8+ APIs (required for local notifications)\n    coreLibraryDesugaring \'com.android.tools:desugar_jdk_libs:2.1.5\''
      );
    } else {
      // Add dependencies section at the end if it doesn't exist
      updatedContent += '''

dependencies {
    // Core library desugaring for Java 8+ APIs (required for local notifications)
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.5'
}
''';
    }
  }
  
  if (content != updatedContent) {
    buildGradleFile.writeAsStringSync(updatedContent);
    print('${ConsoleSymbols.success}  Added desugar dependency to build.gradle');
  }
}

void _updateAndroidManifest() {
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  
  if (!manifestFile.existsSync()) {
    throw Exception('Android manifest file not found');
  }
  
  final content = manifestFile.readAsStringSync();
  
  // Check if notification permissions are already present
  if (content.contains('POST_NOTIFICATIONS')) {
    print('${ConsoleSymbols.success}  Android notification permissions already configured');
    return;
  }
  
  String updatedContent = content;
  
  // Add notification permissions
  final permissions = [
    '<!-- Notification permissions -->',
    '<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />',
  ];
  
  // Find the best place to add permissions - after existing permissions or after manifest tag
  int insertPosition = -1;
  String indent = '    ';
  
  // Try to find existing uses-permission tags to maintain consistency
  final existingPermissionMatch = RegExp(r'(\s*)<uses-permission[^>]*>', multiLine: true).firstMatch(content);
  if (existingPermissionMatch != null) {
    // Place after the last existing permission
    final allPermissionMatches = RegExp(r'(\s*)<uses-permission[^>]*>', multiLine: true).allMatches(content);
    final lastMatch = allPermissionMatches.last;
    insertPosition = lastMatch.end;
    indent = lastMatch.group(1) ?? '    '; // Use same indentation as existing permissions
  } else {
    // No existing permissions, place after manifest tag
    final manifestTagMatch = RegExp(r'<manifest[^>]*>', multiLine: true).firstMatch(content);
    if (manifestTagMatch != null) {
      insertPosition = manifestTagMatch.end;
      indent = '    '; // Standard 4-space indent
    }
  }
  
  if (insertPosition != -1) {
    final permissionsToAdd = permissions.where((permission) => 
      !permission.startsWith('<!--') && !content.contains(permission.trim())
    ).toList();
    
    if (permissionsToAdd.isNotEmpty) {
      final permissionText = permissionsToAdd.map((p) => '$indent$p').join('\n');
      updatedContent = '${content.substring(0, insertPosition)}\n$permissionText${content.substring(insertPosition)}';
    }
  }
  
  if (content != updatedContent) {
    manifestFile.writeAsStringSync(updatedContent);
    print('${ConsoleSymbols.success}  Added notification permissions to AndroidManifest.xml');
  }
}

void _addAndroidProguardRules() {
  final proguardFile = File('android/app/proguard-rules.pro');
  
  // Individual rules to check and add
  final requiredRules = [
    '# Firebase and FCM rules',
    '-keep class com.google.firebase.** { *; }',
    '-keep class com.google.android.gms.** { *; }',
    '-keepattributes *Annotation*',
    '-keepattributes SourceFile,LineNumberTable',
    '-keep public class * extends java.lang.Exception',
    '',
    '# Flutter Local Notifications',
    '-keep class com.dexterous.** { *; }',
    '-keep class androidx.work.** { *; }',
  ];

  String content = '';
  bool fileExists = proguardFile.existsSync();
  
  if (fileExists) {
    content = proguardFile.readAsStringSync();
  }
  
  // Check which rules are missing
  final missingRules = <String>[];
  for (final String rule in requiredRules) {
    if (rule.trim().isEmpty || rule.startsWith('#')) {
      if (!content.contains(rule)) {
        missingRules.add(rule); // Comments and empty lines
      }
    } else {
      if (!content.contains(rule.trim())) {
        missingRules.add(rule); // Actual proguard rules
      }
    }
  }
  
  if (missingRules.isEmpty) {
    print('${ConsoleSymbols.success}  Proguard rules already configured');
    return;
  }
  
  // Add missing rules
  if (!fileExists) {
    proguardFile.createSync(recursive: true);
    proguardFile.writeAsStringSync('${missingRules.join('\n')}\n');
    print('${ConsoleSymbols.success}  Created proguard-rules.pro with Firebase and notification rules');
  } else {
    final updatedContent = '${content.trimRight()}\n\n${missingRules.join('\n')}\n';
    proguardFile.writeAsStringSync(updatedContent);
    print('${ConsoleSymbols.success}  Added missing proguard rules (${missingRules.where((r) => !r.startsWith('#') && r.trim().isNotEmpty).length} rules)');
  }
  
  // Note: proguard-rules.pro reference in build.gradle should be handled elsewhere
  // to avoid conflicts with other commands that might modify build configuration
}

