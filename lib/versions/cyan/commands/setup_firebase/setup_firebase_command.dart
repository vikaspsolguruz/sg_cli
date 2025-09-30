part of '../../cyan.dart';

void _setupFirebase() {
  print('');
  print('🔥 Setting up Firebase configurations...');
  print('');

  // Validate cyan config exists
  if (!_validateCyanConfig()) {
    return;
  }

  try {
    // Get package name
    final packageName = _getBasePackageId();
    final projectName = getModuleName();
    print('🆔 Package ID: $packageName');
    print('📦 Project: $projectName');
    print('');

    // Check if flavors exist
    final hasFlavors = _checkFlavorsExist();

    if (hasFlavors) {
      print('✓ Detected flavor-based project');
      print('  Setting up Firebase for flavors: dev, stage, prod');
      print('');
      _setupFlavoredFirebase(packageName, projectName);
    } else {
      print('ℹ️  No flavors detected - setting up single Firebase configuration');
      print('');
      _setupSingleFirebase(packageName, projectName);
    }
  } catch (e) {
    print('❌ Error during Firebase setup: $e');
  }
}

void _setupFlavoredFirebase(String packageName, String projectName) {
  print('🚀 Setting up flavor-based Firebase configuration...');
  print('');
  
  // Add firebase_core dependency
  print('📦 Adding firebase_core dependency...');
  _addDependencyToPubspec('firebase_core', '^4.1.1');
  _runPubGet();
  print('');
  
  // Generate firebase_options_*.dart files
  _generateFirebaseOptionsDartFiles(packageName);

  // Setup Android Firebase configs
  _setupAndroidFirebase(packageName);

  // Setup iOS Firebase configs
  _setupIOSFirebase(packageName);

  // Inject Firebase initialization into _app_initializer.dart
  print('');
  print('📝 Modifying _app_initializer.dart...');
  _injectFirebaseInitialization(projectName, true);

  print('');
  print('╔════════════════════════════════════════════════════════════════════════════════╗');
  print('║              ✅ Flavor-Based Firebase Setup Complete!                         ║');
  print('╚════════════════════════════════════════════════════════════════════════════════╝');
  print('');
  print('✅ What we did for you:');
  print('   • Added firebase_core: ^4.1.1 to pubspec.yaml');
  print('   • Installed dependencies automatically');
  print('   • Created 3 Firebase option files (dev, stage, prod)');
  print('   • Added Firebase initialization code to your _app_initializer.dart');
  print('   • Created placeholder config files for Android and iOS');
  print('   • Added all necessary imports automatically');
  print('');
  print('📦 Optional Dependencies (Add if needed):');
  print('   You can manually add these to pubspec.yaml:');
  print('');
  print('   dependencies:');
  print('     firebase_analytics: ^11.2.1  # For analytics');
  print('     firebase_auth: ^5.1.4        # For authentication');
  print('     cloud_firestore: ^5.2.1      # For Firestore database');
  print('');
  print('🚀 STEP 2: Get Real Firebase Configuration');
  print('   You need to replace placeholder files with real Firebase configs.');
  print('   Choose ONE of these methods:');
  print('');
  print('   📝 Method A - Using FlutterFire CLI (EASIEST):');
  print('      1. Install FlutterFire CLI:');
  print('         dart pub global activate flutterfire_cli');
  print('');
  print('      2. Configure for DEV flavor:');
  print('         flutterfire configure \\');
  print('           --project=your-firebase-project-id \\');
  print('           --out=lib/firebase_options_dev.dart \\');
  print('           --ios-bundle-id=$packageName.dev \\');
  print('           --android-package-name=$packageName.dev');
  print('');
  print('      3. Configure for STAGE flavor:');
  print('         flutterfire configure \\');
  print('           --project=your-firebase-project-id \\');
  print('           --out=lib/firebase_options_stage.dart \\');
  print('           --ios-bundle-id=$packageName.stage \\');
  print('           --android-package-name=$packageName.stage');
  print('');
  print('      4. Configure for PROD flavor:');
  print('         flutterfire configure \\');
  print('           --project=your-firebase-project-id \\');
  print('           --out=lib/firebase_options_prod.dart \\');
  print('           --ios-bundle-id=$packageName \\');
  print('           --android-package-name=$packageName');
  print('');
  print('   🌐 Method B - Manual Setup from Firebase Console:');
  print('      1. Go to: https://console.firebase.google.com');
  print('      2. Create/select your Firebase project');
  print('      3. Add 3 Android apps with these package names:');
  print('         • Dev:   $packageName.dev');
  print('         • Stage: $packageName.stage');
  print('         • Prod:  $packageName');
  print('      4. Download google-services.json for each and replace:');
  print('         • android/app/src/dev/google-services.json');
  print('         • android/app/src/stage/google-services.json');
  print('         • android/app/src/prod/google-services.json');
  print('      5. Add 3 iOS apps with same bundle IDs as above');
  print('      6. Download GoogleService-Info.plist for each and replace:');
  print('         • ios/config/dev/GoogleService-Info.plist');
  print('         • ios/config/stage/GoogleService-Info.plist');
  print('         • ios/config/prod/GoogleService-Info.plist');
  print('');
  print('🚀 STEP 3: Test Your Setup');
  print('   Run your app with different flavors:');
  print('   • flutter run --flavor dev');
  print('   • flutter run --flavor stage');
  print('   • flutter run --flavor prod');
  print('');
  print('💡 Note: Your _app_initializer.dart already has Firebase initialization code!');
  print('   We automatically added it after WidgetsFlutterBinding.ensureInitialized()');
  print('');
  print('❓ Need Help?');
  print('   • Firebase Setup Guide: https://firebase.google.com/docs/flutter/setup');
  print('   • FlutterFire CLI: https://firebase.flutter.dev/docs/cli');
  print('');
}

void _setupSingleFirebase(String packageName, String projectName) {
  print('🚀 Setting up single Firebase configuration...');
  print('');
  
  // Add firebase_core dependency
  print('📦 Adding firebase_core dependency...');
  _addDependencyToPubspec('firebase_core', '^4.1.1');
  _runPubGet();
  print('');
  
  // Generate single firebase_options.dart file
  final firebaseOptionsFile = File('lib/firebase_options.dart');

  if (!firebaseOptionsFile.existsSync()) {
    final content = _firebaseOptionsDartTemplate('prod', packageName);
    firebaseOptionsFile.writeAsStringSync(content);
    print('✓ Created lib/firebase_options.dart');
  } else {
    print('⚠️  lib/firebase_options.dart already exists, skipping...');
  }

  // Inject Firebase initialization into _app_initializer.dart
  print('');
  print('📝 Modifying _app_initializer.dart...');
  _injectFirebaseInitialization(projectName, false);

  print('');
  print('╔════════════════════════════════════════════════════════════════════════════════╗');
  print('║                   ✅ Firebase Setup Complete!                                  ║');
  print('╚════════════════════════════════════════════════════════════════════════════════╝');
  print('');
  print('✅ What we did for you:');
  print('   • Added firebase_core: ^4.1.1 to pubspec.yaml');
  print('   • Installed dependencies automatically');
  print('   • Created Firebase options file: lib/firebase_options.dart');
  print('   • Added Firebase initialization code to your _app_initializer.dart');
  print('   • Added all necessary imports automatically');
  print('');
  print('📦 Optional Dependencies (Add if needed):');
  print('   You can manually add these to pubspec.yaml:');
  print('');
  print('   dependencies:');
  print('     firebase_analytics: ^11.2.1  # For analytics');
  print('     firebase_auth: ^5.1.4        # For authentication');
  print('     cloud_firestore: ^5.2.1      # For Firestore database');
  print('');
  print('🔥 STEP 2: Get Real Firebase Configuration');
  print('   You need to update firebase_options.dart with real Firebase config.');
  print('   Choose ONE of these methods:');
  print('');
  print('   📝 Method A - Using FlutterFire CLI (EASIEST):');
  print('      1. Install FlutterFire CLI:');
  print('         dart pub global activate flutterfire_cli');
  print('');
  print('      2. Run configuration command:');
  print('         flutterfire configure');
  print('');
  print('      3. Follow the prompts to:');
  print('         • Select your Firebase project (or create new one)');
  print('         • Select platforms (iOS, Android, etc.)');
  print('         • FlutterFire CLI will automatically update firebase_options.dart!');
  print('');
  print('   🌐 Method B - Manual Setup from Firebase Console:');
  print('      1. Go to: https://console.firebase.google.com');
  print('      2. Create/select your Firebase project');
  print('      3. Add Android app:');
  print('         • Package name: $packageName');
  print('         • Download google-services.json');
  print('         • Place it in: android/app/google-services.json');
  print('      4. Add iOS app:');
  print('         • Bundle ID: $packageName');
  print('         • Download GoogleService-Info.plist');
  print('         • Place it in: ios/Runner/GoogleService-Info.plist');
  print('      5. Update lib/firebase_options.dart with values from Firebase console');
  print('');
  print('🚀 STEP 3: Test Your Setup');
  print('   Run your app:');
  print('   • flutter run');
  print('');
  print('💡 Note: Your _app_initializer.dart already has Firebase initialization code!');
  print('   We automatically added it after WidgetsFlutterBinding.ensureInitialized()');
  print('');
  print('❓ Need Help?');
  print('   • Firebase Setup Guide: https://firebase.google.com/docs/flutter/setup');
  print('   • FlutterFire CLI: https://firebase.flutter.dev/docs/cli');
  print('');
}

void _generateFirebaseOptionsDartFiles(String packageName) {
  print('📄 Generating firebase_options_*.dart files...');

  final flavors = ['dev', 'stage', 'prod'];

  for (final flavor in flavors) {
    final firebaseOptionsFile = File('lib/firebase_options_$flavor.dart');

    if (firebaseOptionsFile.existsSync()) {
      print('  ⚠️  firebase_options_$flavor.dart already exists, skipping...');
      continue;
    }

    final content = _firebaseOptionsDartTemplate(flavor, packageName);
    firebaseOptionsFile.writeAsStringSync(content);
    print('  ✓ Created lib/firebase_options_$flavor.dart');
  }

  print('✓ Firebase options files generated');
}

void _setupAndroidFirebase(String packageName) {
  print('🤖 Configuring Android Firebase...');

  final flavors = ['dev', 'stage', 'prod'];

  for (final flavor in flavors) {
    _createAndroidFirebaseConfig(flavor, packageName);
  }

  print('✓ Android Firebase configs generated');
}

void _createAndroidFirebaseConfig(String flavor, String packageName) {
  final firebaseFile = File('android/app/src/$flavor/google-services.json');

  if (firebaseFile.existsSync()) {
    print('  ⚠️  google-services.json already exists for $flavor, skipping...');
    return;
  }

  final placeholderContent = _placeholderFirebaseAndroidConfigTemplate(flavor, packageName);

  firebaseFile.writeAsStringSync(placeholderContent);
  print('  ✓ Created google-services.json for $flavor');
}

void _setupIOSFirebase(String packageName) {
  print('🍎 Configuring iOS Firebase...');

  final flavors = ['dev', 'stage', 'prod'];

  // Create config directory structure
  for (final flavor in flavors) {
    final configDir = Directory('ios/config/$flavor');
    if (!configDir.existsSync()) {
      configDir.createSync(recursive: true);
    }

    _createIOSFirebaseConfig(flavor, packageName);
  }

  print('✓ iOS Firebase configs generated');
}

void _createIOSFirebaseConfig(String flavor, String packageName) {
  final firebaseFile = File('ios/config/$flavor/GoogleService-Info.plist');

  if (firebaseFile.existsSync()) {
    print('  ⚠️  GoogleService-Info.plist already exists for $flavor, skipping...');
    return;
  }

  final placeholderContent = _placeholderFirebaseIOSConfigTemplate(flavor, packageName);

  firebaseFile.writeAsStringSync(placeholderContent);
  print('  ✓ Created GoogleService-Info.plist for $flavor');
}
