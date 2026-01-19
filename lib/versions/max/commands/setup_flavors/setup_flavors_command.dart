part of '../../max.dart';

void _setupFlavors() {
  print('');
  print('🎨 Setting up Flutter flavors (dev, stage, prod)...');
  print('');

  // Validate max config exists
  if (!_validateMaxConfig()) {
    return;
  }

  try {
    final projectName = getModuleName();
    final packageName = _getBasePackageId();
    final appLabel = _getAppLabel();

    print('📦  Project: $projectName');
    print('🆔  Package ID: $packageName');
    print('🏷️  App Label: $appLabel');
    print('');

    print('🔍  Detecting build configuration file...');

    // Detect build file type
    final buildGradleKts = File('android/app/build.gradle.kts');
    final buildGradle = File('android/app/build.gradle');

    final bool isKotlinDsl = buildGradleKts.existsSync();
    final bool isGroovyDsl = buildGradle.existsSync();

    if (!isKotlinDsl && !isGroovyDsl) {
      print('${ConsoleSymbols.error} Error: No build.gradle or build.gradle.kts found in android/app/');
      return;
    }

    final buildFile = isKotlinDsl ? buildGradleKts : buildGradle;
    final buildType = isKotlinDsl ? 'Kotlin DSL' : 'Groovy';

    print('✓ Found: ${buildFile.path.split('/').last} ($buildType)');
    print('');

    // Add product flavors (use appLabel, not projectName!)
    _addProductFlavors(buildFile, isKotlinDsl, appLabel);

    // Create flavor directories
    _createFlavorDirectories();

    // Create iOS flavor configurations (pass appLabel!)
    _createIOSFlavorConfigs(packageName, appLabel);

    // Create Android Studio run configurations
    _createAndroidStudioRunConfigs();

    print('');
    print('╔════════════════════════════════════════════════════════════════════════════════╗');
    print('║                ${ConsoleSymbols.success} Flavors Setup Complete!                                   ║');
    print('╚════════════════════════════════════════════════════════════════════════════════╝');
    print('');
    print('📱 Product flavors added to Android:');
    print('   • dev   - Package: $packageName.dev');
    print('   • stage - Package: $packageName.stage');
    print('   • prod  - Package: $packageName');
    print('');
    print('🍎 iOS Bundle IDs configured:');
    print('   • dev   - Bundle ID: $packageName.dev');
    print('   • stage - Bundle ID: $packageName.stage');
    print('   • prod  - Bundle ID: $packageName');
    print('');
    print('📁 Flavor directories created:');
    print('   • android/app/src/dev/');
    print('   • android/app/src/stage/');
    print('   • android/app/src/prod/');
    print('');
    print('🏃 Android Studio run configurations created:');
    print('   • .run/dev.run.xml');
    print('   • .run/stage.run.xml');
    print('   • .run/prod.run.xml');
    print('');
    print('${ConsoleSymbols.rocket} Next steps:');
    print('   1. Run: sg setup_deeplink   (to configure deep-linking per flavor)');
    print('   2. Run: sg setup_firebase   (to add Firebase configs per flavor)');
    print('');
    print('${ConsoleSymbols.bulb} Test your flavors:');
    print('   flutter run --flavor dev');
    print('   flutter run --flavor stage');
    print('   flutter run --flavor prod');
    print('');
    print('   Or use Android Studio run configurations (select from dropdown)');
    print('');
  } catch (e) {
    print('${ConsoleSymbols.error} Error during flavor setup: $e');
  }
}

bool _validateMaxConfig() {
  final configFile = File('sg_cli.yaml');

  if (!configFile.existsSync()) {
    print('${ConsoleSymbols.error} Error: sg_cli.yaml not found!');
    print('   This command only works with max architecture projects.');
    print('   Run: sg init');
    return false;
  }

  final content = configFile.readAsStringSync();
  if (!content.contains('version: max')) {
    print('${ConsoleSymbols.error} Error: This command only works with max architecture.');
    print('   Current config is not max version.');
    return false;
  }

  return true;
}

void _createFlavorDirectories() {
  print('📁 Creating flavor directories...');

  final flavors = ['dev', 'stage', 'prod'];

  for (final flavor in flavors) {
    final flavorDir = Directory('android/app/src/$flavor');
    if (!flavorDir.existsSync()) {
      flavorDir.createSync(recursive: true);
      print('  ✓ Created android/app/src/$flavor/');
    }
  }

  print('✓ Flavor directories created');
}

void _createIOSFlavorConfigs(String packageName, String appLabel) {
  print('🍎 Creating iOS flavor configurations...');

  // Ensure Flutter directory exists
  final flutterDir = Directory('ios/Flutter');
  if (!flutterDir.existsSync()) {
    print('  ⚠️  ios/Flutter directory not found, skipping iOS configuration...');
    return;
  }

  final flavors = ['dev', 'stage', 'prod'];

  for (final flavor in flavors) {
    final xcconfigFile = File('ios/Flutter/$flavor.xcconfig');

    if (xcconfigFile.existsSync()) {
      print('  ⚠️  $flavor.xcconfig already exists, skipping...');
      continue;
    }

    final xcconfigContent = _iosXcconfigTemplate(flavor, packageName, appLabel);
    xcconfigFile.writeAsStringSync(xcconfigContent);

    final bundleId = flavor == 'prod' ? packageName : '$packageName.$flavor';
    final displayName = flavor == 'prod' ? appLabel : '${flavor[0].toUpperCase()}${flavor.substring(1)} $appLabel';
    print('  ✓ Created $flavor.xcconfig → Bundle ID: $bundleId, Display Name: $displayName');
  }

  print('✓ iOS flavor configurations created');
}

void _createAndroidStudioRunConfigs() {
  print('🏃 Creating Android Studio run configurations...');

  // Create .run directory
  final runDir = Directory('.run');
  if (!runDir.existsSync()) {
    runDir.createSync(recursive: true);
  }

  final flavors = ['dev', 'stage', 'prod'];

  for (final flavor in flavors) {
    final runConfigFile = File('.run/$flavor.run.xml');

    if (runConfigFile.existsSync()) {
      print('  ⚠️  $flavor.run.xml already exists, skipping...');
      continue;
    }

    final runConfigContent = _androidStudioRunConfigTemplate(flavor);
    runConfigFile.writeAsStringSync(runConfigContent);
    print('  ✓ Created .run/$flavor.run.xml');
  }

  print('✓ Android Studio run configurations created');
}
