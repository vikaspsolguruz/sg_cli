part of '../cyan.dart';

void _setupIOSNotifications() {
  print('🍎 Configuring iOS for FCM and local notifications...');
  
  try {
    _updateIOSInfoPlist();
    _updateIOSAppDelegate();
    _addIOSEntitlements();
    print('${ConsoleSymbols.success}  iOS notification support configured');
  } catch (e) {
    print('${ConsoleSymbols.warning}  Failed to configure iOS notifications: $e');
  }
}

void _updateIOSInfoPlist() {
  final infoPlistFile = File('ios/Runner/Info.plist');
  
  if (!infoPlistFile.existsSync()) {
    throw Exception('iOS Info.plist file not found');
  }
  
  final content = infoPlistFile.readAsStringSync();
  
  // Check if notification permissions are already present
  if (content.contains('UIBackgroundModes') && content.contains('remote-notification')) {
    print('${ConsoleSymbols.success}  iOS notification permissions already configured');
    return;
  }
  
  String updatedContent = content;
  
  // Add background modes for notifications
  final backgroundModes = '''
	<key>UIBackgroundModes</key>
	<array>
		<string>background-fetch</string>
		<string>remote-notification</string>
	</array>''';
  
  // Add before closing </dict> tag
  if (!content.contains('UIBackgroundModes')) {
    updatedContent = updatedContent.replaceFirst(
      '</dict>\n</plist>',
      '$backgroundModes\n</dict>\n</plist>'
    );
  }
  
  if (content != updatedContent) {
    infoPlistFile.writeAsStringSync(updatedContent);
    print('${ConsoleSymbols.success}  Added background modes to Info.plist');
  }
}

void _updateIOSAppDelegate() {
  final appDelegateFile = File('ios/Runner/AppDelegate.swift');
  
  if (!appDelegateFile.existsSync()) {
    // Try AppDelegate.m for Objective-C
    final appDelegateObjCFile = File('ios/Runner/AppDelegate.m');
    if (appDelegateObjCFile.existsSync()) {
      _updateIOSAppDelegateObjC(appDelegateObjCFile);
      return;
    }
    throw Exception('iOS AppDelegate file not found');
  }
  
  final content = appDelegateFile.readAsStringSync();
  
  // Check if FCM is already configured
  if (content.contains('FirebaseApp.configure()') || content.contains('Firebase')) {
    print('${ConsoleSymbols.success}  iOS Firebase already configured');
    return;
  }
  
  String updatedContent = content;
  
  // Add Firebase import
  if (!content.contains('import Firebase')) {
    updatedContent = updatedContent.replaceFirst(
      'import Flutter',
      'import Flutter\nimport Firebase'
    );
  }
  
  // Add Firebase configuration in didFinishLaunchingWithOptions
  if (!content.contains('FirebaseApp.configure()')) {
    final didFinishLaunchingPattern = RegExp(
      r'func application\([^)]*didFinishLaunchingWithOptions[^{]*\{([^}]*(?:\{[^}]*\}[^}]*)*)\}',
      multiLine: true,
      dotAll: true
    );
    
    final match = didFinishLaunchingPattern.firstMatch(content);
    if (match != null) {
      final methodBody = match.group(1)!;
      if (!methodBody.contains('FirebaseApp.configure()')) {
        final newMethodBody = methodBody.replaceFirst(
          RegExp(r'(\s*)(GeneratedPluginRegistrant\.register)'),
          '\\1// Configure Firebase\n\\1FirebaseApp.configure()\n\\1\n\\1\\2'
        );
        updatedContent = content.replaceFirst(methodBody, newMethodBody);
      }
    }
  }
  
  if (content != updatedContent) {
    appDelegateFile.writeAsStringSync(updatedContent);
    print('${ConsoleSymbols.success}  Added Firebase configuration to AppDelegate.swift');
  }
}

void _updateIOSAppDelegateObjC(File appDelegateFile) {
  final content = appDelegateFile.readAsStringSync();
  
  // Check if FCM is already configured
  if (content.contains('[FIRApp configure]') || content.contains('Firebase')) {
    print('${ConsoleSymbols.success}  iOS Firebase already configured');
    return;
  }
  
  String updatedContent = content;
  
  // Add Firebase import
  if (!content.contains('@import Firebase;')) {
    updatedContent = updatedContent.replaceFirst(
      '#import "AppDelegate.h"',
      '#import "AppDelegate.h"\n@import Firebase;'
    );
  }
  
  // Add Firebase configuration in didFinishLaunchingWithOptions
  if (!content.contains('[FIRApp configure]')) {
    final didFinishLaunchingPattern = RegExp(
      r'- \(BOOL\)application:\([^)]*\)application didFinishLaunchingWithOptions:\([^)]*\) \{([^}]*(?:\{[^}]*\}[^}]*)*)\}',
      multiLine: true,
      dotAll: true
    );
    
    final match = didFinishLaunchingPattern.firstMatch(content);
    if (match != null) {
      final methodBody = match.group(1)!;
      if (!methodBody.contains('[FIRApp configure]')) {
        final newMethodBody = methodBody.replaceFirst(
          RegExp(r'(\s*)(\[GeneratedPluginRegistrant)'),
          '\\1// Configure Firebase\n\\1[FIRApp configure];\n\\1\n\\1\\2'
        );
        updatedContent = content.replaceFirst(methodBody, newMethodBody);
      }
    }
  }
  
  if (content != updatedContent) {
    appDelegateFile.writeAsStringSync(updatedContent);
    print('${ConsoleSymbols.success}  Added Firebase configuration to AppDelegate.m');
  }
}

void _addIOSEntitlements() {
  final entitlementsFile = File('ios/Runner/Runner.entitlements');
  
  const entitlementsContent = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>aps-environment</key>
	<string>development</string>
</dict>
</plist>
''';

  if (!entitlementsFile.existsSync()) {
    // Create new entitlements file
    entitlementsFile.createSync(recursive: true);
    entitlementsFile.writeAsStringSync(entitlementsContent);
    print('${ConsoleSymbols.success}  Created Runner.entitlements with push notification support');
  } else {
    // Check if push notifications entitlement already exists
    final content = entitlementsFile.readAsStringSync();
    if (content.contains('aps-environment')) {
      print('${ConsoleSymbols.success}  iOS push notification entitlements already configured');
      return;
    }
    
    // Add aps-environment to existing entitlements
    if (content.contains('<dict>') && content.contains('</dict>')) {
      final updatedContent = content.replaceFirst(
        '</dict>',
        '\t<key>aps-environment</key>\n\t<string>development</string>\n</dict>'
      );
      entitlementsFile.writeAsStringSync(updatedContent);
      print('${ConsoleSymbols.success}  Added push notification entitlement to existing Runner.entitlements');
    } else {
      // Fallback: replace entire file if format is unexpected
      entitlementsFile.writeAsStringSync(entitlementsContent);
      print('${ConsoleSymbols.success}  Updated Runner.entitlements with push notification support');
    }
  }
}
