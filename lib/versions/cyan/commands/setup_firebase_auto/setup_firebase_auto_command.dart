part of '../../cyan.dart';

/// Automated Firebase setup using FlutterFire CLI
/// This command guides users through Firebase setup with real configs
Future<void> setupFirebaseAuto() async {
  try {
    print('');
    print('╔════════════════════════════════════════════════════════════════════════════════╗');
    print('║            🔥 Automated Firebase Setup with FlutterFire CLI                   ║');
    print('╚════════════════════════════════════════════════════════════════════════════════╝');
    print('');

    // Get package name and project name
    final packageName = _getBasePackageId();
    final projectName = getModuleName();
    print(' 🆔 Package: $packageName');
    print('');
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
      await _setupFirebaseAutoFlavored(packageName, projectName);
    } else {
      print(' ℹ️  No flavors detected - setting up single Firebase configuration');
      print('');
      await _setupFirebaseAutoSingle(packageName, projectName);
    }
  } catch (e) {
    print(' ❌ Error during Firebase setup: $e');
  }
}

/// Check if FlutterFire CLI is installed and user is logged in
bool _checkPrerequisites() {
  print('🔍 Checking prerequisites...');
  print('');

  // Check if FlutterFire CLI is installed
  if (!_isFlutterFireInstalled()) {
    print(' ❌ FlutterFire CLI is not installed!');
    print('');
    print(' 📦 Install it by running:');
    print('   dart pub global activate flutterfire_cli');
    print('');
    print('After installation, run this command again.');
    return false;
  }

  // Check if Firebase CLI is installed (optional but recommended)
  if (!_isFirebaseCliInstalled()) {
    print(' ⚠️  Firebase CLI not found (optional)');
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
Future<void> _setupFirebaseAutoFlavored(String packageName, String projectName) async {
  print(' 📋 Setting up Firebase for flavored project...');
  print('');

  // Step 1: List Firebase projects and let user select ONE
  print(' 🔍 Fetching your Firebase projects...');
  final selectedProject = await _selectFirebaseProject();

  if (selectedProject == null) {
    print(' ❌ Could not select Firebase project');
    return;
  }

  print(' ✅ Selected project: ${selectedProject['displayName']}');
  print('');

  // Step 2: Get list of apps in the selected project
  print(' 🔍 Checking apps in project...');
  final apps = await _getFirebaseApps(selectedProject['projectId']);

  if (apps == null) {
    print(' ❌ Could not fetch apps from project');
    return;
  }

  print(' ✅ Found ${apps.length} app(s) in project');
  print('');

  // Step 3: Check which flavor apps exist
  final flavors = [
    {'name': 'dev', 'package': '$packageName.dev'},
    {'name': 'stage', 'package': '$packageName.stage'},
    {'name': 'prod', 'package': packageName},
  ];

  final missingApps = <String>[];
  final existingApps = <Map<String, String>>[];

  for (final flavor in flavors) {
    final flavorName = flavor['name']!;
    final flavorPackage = flavor['package']!;

    // Check if app with this package name exists
    final appExists = apps.any((app) {
      final appPackage = app['packageName'] ?? app['bundleId'] ?? '';
      return appPackage == flavorPackage;
    });

    if (appExists) {
      existingApps.add(flavor);
      print('  ✓ $flavorName: Found app with package $flavorPackage');
    } else {
      missingApps.add('$flavorName ($flavorPackage)');
      print('  ✗ $flavorName: Missing app with package $flavorPackage');
    }
  }

  print('');

  // If apps are missing, inform user
  if (missingApps.isNotEmpty) {
    print(' ⚠️  Missing apps in Firebase project:');
    for (final missing in missingApps) {
      print('   • $missing');
    }
    print('');
    print(' 📝 Please add these apps in Firebase Console:');
    print('   https://console.firebase.google.com/project/${selectedProject['projectId']}/settings/general');
    print('');

    if (existingApps.isEmpty) {
      print(' ❌ No matching apps found. Setup cannot continue.');
      return;
    }

    print(' 💡 Continuing with available apps only...');
    print('');
  }

  // Step 4: Add firebase_core dependency
  print(' 📦 Adding firebase_core dependency...');
  _addDependencyToPubspec('firebase_core', '^4.1.1');
  _runPubGet();
  print('');

  // Step 5: Generate configs for existing apps
  for (final flavor in existingApps) {
    final flavorName = flavor['name']!;
    final flavorPackage = flavor['package']!;

    print('═══════════════════════════════════════════════════════════════');
    print('🔧 Configuring Firebase for ${flavorName.toUpperCase()} flavor');
    print('═══════════════════════════════════════════════════════════════');
    print('');

    if (!await _runFlutterFireConfigureWithProject(
      selectedProject['projectId'],
      flavorName,
      flavorPackage,
    )) {
      print(' ⚠️  Failed to configure Firebase for $flavorName');
    }

    print('');
  }

  // Step 6: Inject Firebase initialization code
  print(' 📝 Modifying _app_initializer.dart...');
  _injectFirebaseInitialization(projectName, true);

  // Show success message
  _showSuccessMessage(true, packageName);
}

/// Select Firebase project from list
Future<Map<String, dynamic>?> _selectFirebaseProject() async {
  try {
    // Get list of projects
    final result = Process.runSync(
      'firebase',
      ['projects:list', '--json'],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      print(' ❌ Failed to list Firebase projects');
      print('');

      // Check stderr for error details
      final stderr = result.stderr.toString();
      if (stderr.contains('not logged in') || stderr.contains('login') || stderr.contains('authenticate')) {
        print(' 💡 You need to login to Firebase first:');
        print('   firebase login');
      } else if (stderr.isNotEmpty) {
        print('Error: $stderr');
      }

      return null;
    }

    // Parse JSON response
    final rawOutput = result.stdout.toString();
    final decoded = jsonDecode(rawOutput) as Map<String, dynamic>;

    // Firebase CLI wraps response in {status: "success", result: [...]}
    if (decoded['status'] != 'success') {
      print(' ❌ Firebase CLI returned error status');
      final error = decoded['error'] ?? decoded['message'] ?? 'Unknown error';
      print('Error: $error');
      print('');

      // Check for common error types
      final errorStr = error.toString().toLowerCase();
      if (errorStr.contains('not logged in') || errorStr.contains('login') || errorStr.contains('authenticate')) {
        print(' 💡 You need to login to Firebase first:');
        print('   firebase login');
      }

      return null;
    }

    // Extract projects from result
    final projects = decoded['result'] as List?;

    if (projects == null || projects.isEmpty) {
      print(' ❌ No Firebase projects found');
      print('');
      print(' 💡 Create a project at:');
      print('   https://console.firebase.google.com');
      return null;
    }

    // Show projects to user
    print('');
    print('Available Firebase projects:');
    for (int i = 0; i < projects.length; i++) {
      final project = projects[i];
      print('  ${i + 1}. ${project['displayName']} (${project['projectId']})');
    }
    print('');
    print(' ❓ Select a project (1-${projects.length}):');

    final input = stdin.readLineSync();
    final selection = int.tryParse(input ?? '');

    if (selection == null || selection < 1 || selection > projects.length) {
      print(' ❌ Invalid selection');
      return null;
    }

    return projects[selection - 1] as Map<String, dynamic>;
  } catch (e) {
    print(' ❌ Error listing projects: $e');
    print('');
    print(' 💡 Make sure Firebase CLI is installed and you are logged in:');
    print('   npm install -g firebase-tools');
    print('   firebase login');
    return null;
  }
}

/// Get list of apps in a Firebase project
Future<List<Map<String, dynamic>>?> _getFirebaseApps(String projectId) async {
  try {
    final result = Process.runSync(
      'firebase',
      ['apps:list', '--project=$projectId', '--json'],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      print(' ⚠️  Failed to list apps in project');
      return null;
    }

    final data = jsonDecode(result.stdout.toString());

    // Combine Android and iOS apps
    final apps = <Map<String, dynamic>>[];

    if (data['android'] != null) {
      apps.addAll((data['android'] as List).cast<Map<String, dynamic>>());
    }
    if (data['ios'] != null) {
      apps.addAll((data['ios'] as List).cast<Map<String, dynamic>>());
    }

    return apps;
  } catch (e) {
    print(' ⚠️  Error getting apps: $e');
    return null;
  }
}

/// Run FlutterFire configure with specific project
Future<bool> _runFlutterFireConfigureWithProject(
  String projectId,
  String flavor,
  String packageName,
) async {
  try {
    final args = [
      'configure',
      '--project=$projectId',
      '--out=lib/firebase_options_$flavor.dart',
      '--ios-bundle-id=$packageName',
      '--android-package-name=$packageName',
      '--yes', // Auto-confirm
    ];

    print(' 🔄 Running: flutterfire ${args.join(' ')}');
    print('');

    final process = await Process.start(
      'flutterfire',
      args,
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await process.exitCode;

    if (exitCode == 0) {
      print(' ✅ Firebase configured successfully for $flavor');
      return true;
    } else {
      print(' ❌ Configuration failed');
      return false;
    }
  } catch (e) {
    print(' ❌ Error: $e');
    return false;
  }
}

/// Setup Firebase for non-flavored projects using FlutterFire CLI
Future<void> _setupFirebaseAutoSingle(String packageName, String projectName) async {
  print(' 📋 Prerequisites:');
  print('   You need to have created a Firebase project in Firebase Console with:');
  print('   ✓ Android app with package name: $packageName');
  print('   ✓ iOS app with bundle ID: $packageName');
  print('');

  // Ask user if they've completed the prerequisites
  print('❓ Have you created this Firebase project? (y/n)');
  final answer = stdin.readLineSync();

  if (answer?.toLowerCase() != 'y') {
    print('');
    print(' 📝 Please complete these steps:');
    print('   1. Go to: https://console.firebase.google.com');
    print('   2. Create a Firebase project (or use existing one)');
    print('   3. Add Android and iOS apps with the package name above');
    print('   4. Run this command again: sg setup_firebase_auto');
    print('');
    return;
  }

  print('');
  print(' 🚀 Great! Let\'s configure Firebase...');
  print('');

  // Add firebase_core dependency
  print(' 📦 Adding firebase_core dependency...');
  _addDependencyToPubspec('firebase_core', '^4.1.1');
  _runPubGet();
  print('');

  // Run FlutterFire configure
  print(' 🔧 Running FlutterFire CLI...');
  print('');

  if (!await _runFlutterFireConfigure('', packageName)) {
    print(' ⚠️  Failed to configure Firebase');
    print('   Please configure manually using:');
    print('   flutterfire configure');
    return;
  }

  // Inject Firebase initialization code
  print('');
  print(' 📝 Modifying _app_initializer.dart...');
  _injectFirebaseInitialization(projectName, false);

  // Show success message
  _showSuccessMessage(false, packageName);
}

/// Run FlutterFire configure command
Future<bool> _runFlutterFireConfigure(String flavor, String packageName) async {
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

    print(' 🔄 Running: flutterfire ${args.join(' ')}');
    print('');

    // Run FlutterFire configure interactively
    // Use inheritStdio mode to allow full user interaction
    final process = await Process.start(
      'flutterfire',
      args,
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await process.exitCode;

    print('');

    if (exitCode == 0) {
      print(' ✅ Firebase configured successfully${flavor.isNotEmpty ? ' for $flavor' : ''}');
      return true;
    } else {
      print(' ❌ FlutterFire configure failed (Exit code: $exitCode)');
      print('');
      print(' 💡 Common issues:');
      print('   • Not logged in: Run "firebase login"');
      print('   • No projects: Create one at https://console.firebase.google.com');
      print('   • No apps in project: Add Android/iOS apps with correct package names');
      return false;
    }
  } catch (e) {
    print('');
    print(' ❌ Error running FlutterFire CLI: $e');
    print('');
    print(' 💡 Make sure FlutterFire CLI is installed:');
    print('   dart pub global activate flutterfire_cli');
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
  print(' ✅ What we did for you:');
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
  print(' 🚀 Your app is ready to use Firebase!');
  print('');

  if (hasFlavors) {
    print(' 💡 Test your setup with different flavors:');
    print('   • flutter run --flavor dev');
    print('   • flutter run --flavor stage');
    print('   • flutter run --flavor prod');
  } else {
    print(' 💡 Test your setup:');
    print('   • flutter run');
  }

  print('');
  print(' 📚 Learn more:');
  print('   • Firebase Docs: https://firebase.google.com/docs/flutter/setup');
  print('   • FlutterFire CLI: https://firebase.flutter.dev/docs/cli');
  print('');
}
