part of '../../cyan.dart';

/// Automated Firebase setup using FlutterFire CLI
/// This command guides users through Firebase setup with real configs
void setupFirebaseAuto() {
  try {
    print('');
    print('╔════════════════════════════════════════════════════════════════════════════════╗');
    print('║            🔥 Automated Firebase Setup with FlutterFire CLI                   ║');
    print('╚════════════════════════════════════════════════════════════════════════════════╝');
    print('');
    
    // Get package name and project name
    final packageName = _getBasePackageId();
    final projectName = getModuleName();
    print('🆔 Package ID: $packageName');
    print('📦 Project: $projectName');
    print('');
    
    // Step 1: Pre-flight checks
    if (!_checkPrerequisites()) {
      return;
    }
    
    // Step 2: Check if flavors exist
    final hasFlavors = _checkFlavorsExist();
    
    if (hasFlavors) {
      print('✓ Detected flavor-based project');
      print('  Setting up Firebase for flavors: dev, stage, prod');
      print('');
      _setupFirebaseAutoFlavored(packageName, projectName);
    } else {
      print('ℹ️  No flavors detected - setting up single Firebase configuration');
      print('');
      _setupFirebaseAutoSingle(packageName, projectName);
    }
    
  } catch (e) {
    print('❌ Error during Firebase setup: $e');
  }
}

/// Check if FlutterFire CLI is installed and user is logged in
bool _checkPrerequisites() {
  print('🔍 Checking prerequisites...');
  print('');
  
  // Check if FlutterFire CLI is installed
  if (!_isFlutterFireInstalled()) {
    print('❌ FlutterFire CLI is not installed!');
    print('');
    print('📦 Install it by running:');
    print('   dart pub global activate flutterfire_cli');
    print('');
    print('After installation, run this command again.');
    return false;
  }
  
  print('✅ FlutterFire CLI is installed');
  
  // Check if Firebase CLI is installed (optional but recommended)
  if (_isFirebaseCliInstalled()) {
    print('✅ Firebase CLI is installed');
  } else {
    print('⚠️  Firebase CLI not found (optional)');
  }
  
  print('');
  return true;
}

/// Check if FlutterFire CLI is installed
bool _isFlutterFireInstalled() {
  try {
    final result = Process.runSync('flutterfire', ['--version']);
    return result.exitCode == 0;
  } catch (e) {
    return false;
  }
}

/// Check if Firebase CLI is installed
bool _isFirebaseCliInstalled() {
  try {
    final result = Process.runSync('firebase', ['--version']);
    return result.exitCode == 0;
  } catch (e) {
    return false;
  }
}

/// Setup Firebase for flavored projects using FlutterFire CLI
void _setupFirebaseAutoFlavored(String packageName, String projectName) {
  print('📋 Prerequisites for Flavored Projects:');
  print('   You need to have created 3 Firebase projects in Firebase Console:');
  print('   • One for DEV environment');
  print('   • One for STAGE environment');
  print('   • One for PROD environment');
  print('');
  print('   Each project should have:');
  print('   ✓ Android app with package name: $packageName.dev / $packageName.stage / $packageName');
  print('   ✓ iOS app with bundle ID: $packageName.dev / $packageName.stage / $packageName');
  print('');
  
  // Ask user if they've completed the prerequisites
  print('❓ Have you created these Firebase projects? (y/n)');
  final answer = stdin.readLineSync();
  
  if (answer?.toLowerCase() != 'y') {
    print('');
    print('📝 Please complete these steps:');
    print('   1. Go to: https://console.firebase.google.com');
    print('   2. Create 3 Firebase projects (or use existing ones)');
    print('   3. For each project, add Android and iOS apps with the package names above');
    print('   4. Run this command again: sg setup_firebase_auto');
    print('');
    return;
  }
  
  print('');
  print('🚀 Great! Let\'s configure Firebase for each flavor...');
  print('');
  
  // Add firebase_core dependency
  print('📦 Adding firebase_core dependency...');
  _addDependencyToPubspec('firebase_core', '^4.1.1');
  _runPubGet();
  print('');
  
  // Configure Firebase for each flavor
  final flavors = [
    {'name': 'dev', 'suffix': '.dev'},
    {'name': 'stage', 'suffix': '.stage'},
    {'name': 'prod', 'suffix': ''},
  ];
  
  for (final flavor in flavors) {
    final flavorName = flavor['name']!;
    final packageSuffix = flavor['suffix']!;
    
    print('');
    print('═══════════════════════════════════════════════════════════════');
    print('🔧 Configuring Firebase for ${flavorName.toUpperCase()} flavor');
    print('═══════════════════════════════════════════════════════════════');
    print('');
    
    if (!_runFlutterFireConfigure(flavorName, packageName + packageSuffix)) {
      print('⚠️  Failed to configure Firebase for $flavorName');
      print('   Please configure manually using:');
      print('   flutterfire configure --out=lib/firebase_options_$flavorName.dart');
      return;
    }
  }
  
  // Inject Firebase initialization code
  print('');
  print('📝 Modifying _app_initializer.dart...');
  _injectFirebaseInitialization(projectName, true);
  
  // Show success message
  _showSuccessMessage(true, packageName);
}

/// Setup Firebase for non-flavored projects using FlutterFire CLI
void _setupFirebaseAutoSingle(String packageName, String projectName) {
  print('📋 Prerequisites:');
  print('   You need to have created a Firebase project in Firebase Console with:');
  print('   ✓ Android app with package name: $packageName');
  print('   ✓ iOS app with bundle ID: $packageName');
  print('');
  
  // Ask user if they've completed the prerequisites
  print('❓ Have you created this Firebase project? (y/n)');
  final answer = stdin.readLineSync();
  
  if (answer?.toLowerCase() != 'y') {
    print('');
    print('📝 Please complete these steps:');
    print('   1. Go to: https://console.firebase.google.com');
    print('   2. Create a Firebase project (or use existing one)');
    print('   3. Add Android and iOS apps with the package name above');
    print('   4. Run this command again: sg setup_firebase_auto');
    print('');
    return;
  }
  
  print('');
  print('🚀 Great! Let\'s configure Firebase...');
  print('');
  
  // Add firebase_core dependency
  print('📦 Adding firebase_core dependency...');
  _addDependencyToPubspec('firebase_core', '^4.1.1');
  _runPubGet();
  print('');
  
  // Run FlutterFire configure
  print('🔧 Running FlutterFire CLI...');
  print('');
  
  if (!_runFlutterFireConfigure('', packageName)) {
    print('⚠️  Failed to configure Firebase');
    print('   Please configure manually using:');
    print('   flutterfire configure');
    return;
  }
  
  // Inject Firebase initialization code
  print('');
  print('📝 Modifying _app_initializer.dart...');
  _injectFirebaseInitialization(projectName, false);
  
  // Show success message
  _showSuccessMessage(false, packageName);
}

/// Run FlutterFire configure command
bool _runFlutterFireConfigure(String flavor, String packageName) {
  try {
    final args = <String>['configure'];
    
    // Add output file parameter for flavored projects
    if (flavor.isNotEmpty) {
      args.addAll([
        '--out=lib/firebase_options_$flavor.dart',
        '--ios-bundle-id=$packageName',
        '--android-package-name=$packageName',
      ]);
    }
    
    // Run FlutterFire configure interactively
    final process = Process.runSync('flutterfire', args, runInShell: true);
    
    if (process.exitCode == 0) {
      print('✅ Firebase configured successfully${flavor.isNotEmpty ? ' for $flavor' : ''}');
      return true;
    } else {
      print('❌ FlutterFire configure failed');
      if (process.stderr.toString().isNotEmpty) {
        print('   Error: ${process.stderr}');
      }
      return false;
    }
  } catch (e) {
    print('❌ Error running FlutterFire CLI: $e');
    return false;
  }
}

/// Show success message
void _showSuccessMessage(bool hasFlavors, String packageName) {
  print('');
  print('╔════════════════════════════════════════════════════════════════════════════════╗');
  print('║              ✅ Automated Firebase Setup Complete!                            ║');
  print('╚════════════════════════════════════════════════════════════════════════════════╝');
  print('');
  print('✅ What we did for you:');
  print('   • Added firebase_core: ^4.1.1 to pubspec.yaml');
  print('   • Installed dependencies automatically');
  
  if (hasFlavors) {
    print('   • Generated firebase_options_dev.dart with REAL config');
    print('   • Generated firebase_options_stage.dart with REAL config');
    print('   • Generated firebase_options_prod.dart with REAL config');
  } else {
    print('   • Generated firebase_options.dart with REAL config');
  }
  
  print('   • Added Firebase initialization code to _app_initializer.dart');
  print('   • Added all necessary imports automatically');
  print('');
  print('🚀 Your app is ready to use Firebase!');
  print('');
  
  if (hasFlavors) {
    print('💡 Test your setup with different flavors:');
    print('   • flutter run --flavor dev');
    print('   • flutter run --flavor stage');
    print('   • flutter run --flavor prod');
  } else {
    print('💡 Test your setup:');
    print('   • flutter run');
  }
  
  print('');
  print('📚 Learn more:');
  print('   • Firebase Docs: https://firebase.google.com/docs/flutter/setup');
  print('   • FlutterFire CLI: https://firebase.flutter.dev/docs/cli');
  print('');
}
