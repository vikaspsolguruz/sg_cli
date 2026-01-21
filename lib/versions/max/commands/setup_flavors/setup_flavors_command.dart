part of '../../max.dart';

void _setupFlavors() {
  ConsoleLogger.blank();
  ConsoleLogger.raw('🎨 Setting up Flutter flavors (dev, stage, prod)...');
  ConsoleLogger.blank();

  // Validate max config exists
  if (!_validateMaxConfig()) {
    return;
  }

  try {
    final projectName = getModuleName();
    final packageName = _getBasePackageId();
    final appLabel = _getAppLabel();

    ConsoleLogger.info('Project: $projectName');
    ConsoleLogger.info('Package ID: $packageName');
    ConsoleLogger.info('App Label: $appLabel');
    ConsoleLogger.blank();

    ConsoleLogger.info('Detecting build configuration file...');

    // Detect build file type
    final buildGradleKts = File('android/app/build.gradle.kts');
    final buildGradle = File('android/app/build.gradle');

    final bool isKotlinDsl = buildGradleKts.existsSync();
    final bool isGroovyDsl = buildGradle.existsSync();

    if (!isKotlinDsl && !isGroovyDsl) {
      ConsoleLogger.error('No build.gradle or build.gradle.kts found in android/app/');
      return;
    }

    final buildFile = isKotlinDsl ? buildGradleKts : buildGradle;
    final buildType = isKotlinDsl ? 'Kotlin DSL' : 'Groovy';

    ConsoleLogger.success('Found: ${buildFile.path.split('/').last} ($buildType)');
    ConsoleLogger.blank();

    // Add product flavors (use appLabel, not projectName!)
    _addProductFlavors(buildFile, isKotlinDsl, appLabel);

    // Create flavor directories
    _createFlavorDirectories();

    // Create iOS flavor configurations (pass appLabel!)
    _createIOSFlavorConfigs(packageName, appLabel);

    // Create Android Studio run configurations
    _createAndroidStudioRunConfigs();

    ConsoleLogger.blank();
    ConsoleLogger.divider(title: '                Flavors Setup Complete!                                   ');
    ConsoleLogger.blank();
    ConsoleLogger.info('Product flavors added to Android:');
    ConsoleLogger.list(['dev   - Package: $packageName.dev', 'stage - Package: $packageName.stage', 'prod  - Package: $packageName']);
    ConsoleLogger.blank();
    ConsoleLogger.info('iOS Bundle IDs configured:');
    ConsoleLogger.list(['dev   - Bundle ID: $packageName.dev', 'stage - Bundle ID: $packageName.stage', 'prod  - Bundle ID: $packageName']);
    ConsoleLogger.blank();
    ConsoleLogger.info('Flavor directories created:');
    ConsoleLogger.list(['android/app/src/dev/', 'android/app/src/stage/', 'android/app/src/prod/']);
    ConsoleLogger.blank();
    ConsoleLogger.raw('🏃 Android Studio run configurations created:');
    ConsoleLogger.list(['.run/dev.run.xml', '.run/stage.run.xml', '.run/prod.run.xml']);
    ConsoleLogger.blank();
    ConsoleLogger.info('Next steps:');
    ConsoleLogger.list(['1. Run: sg setup_deeplink   (to configure deep-linking per flavor)', '2. Run: sg setup_firebase   (to add Firebase configs per flavor)']);
    ConsoleLogger.blank();
    ConsoleLogger.info('Test your flavors:');
    ConsoleLogger.list(['flutter run --flavor dev', 'flutter run --flavor stage', 'flutter run --flavor prod']);
    ConsoleLogger.blank();
    ConsoleLogger.info('Or use Android Studio run configurations (select from dropdown)');
    ConsoleLogger.blank();
  } catch (e) {
    ConsoleLogger.error('Flavor setup failed: $e');
  }
}

bool _validateMaxConfig() {
  final configFile = File('sg_cli.yaml');

  if (!configFile.existsSync()) {
    ConsoleLogger.error('sg_cli.yaml not found!');
    ConsoleLogger.info('This command only works with max architecture projects.');
    ConsoleLogger.info('Run: sg init');
    return false;
  }

  final content = configFile.readAsStringSync();
  if (!content.contains('version: max')) {
    ConsoleLogger.error('This command only works with max architecture.');
    ConsoleLogger.info('Current config is not max version.');
    return false;
  }

  return true;
}

void _createFlavorDirectories() {
  ConsoleLogger.info('Creating flavor directories...');

  final flavors = ['dev', 'stage', 'prod'];

  for (final flavor in flavors) {
    final flavorDir = Directory('android/app/src/$flavor');
    if (!flavorDir.existsSync()) {
      flavorDir.createSync(recursive: true);
      ConsoleLogger.success('Created android/app/src/$flavor/');
    }
  }

  ConsoleLogger.success('Flavor directories created');
}

void _createIOSFlavorConfigs(String packageName, String appLabel) {
  ConsoleLogger.info('Creating iOS flavor configurations...');

  // Ensure Flutter directory exists
  final flutterDir = Directory('ios/Flutter');
  if (!flutterDir.existsSync()) {
    ConsoleLogger.warning('ios/Flutter directory not found, skipping iOS configuration');
    return;
  }

  final flavors = ['dev', 'stage', 'prod'];

  for (final flavor in flavors) {
    final xcconfigFile = File('ios/Flutter/$flavor.xcconfig');

    if (xcconfigFile.existsSync()) {
      ConsoleLogger.warning('$flavor.xcconfig already exists, skipping');
      continue;
    }

    final xcconfigContent = _iosXcconfigTemplate(flavor, packageName, appLabel);
    xcconfigFile.writeAsStringSync(xcconfigContent);

    final bundleId = flavor == 'prod' ? packageName : '$packageName.$flavor';
    final displayName = flavor == 'prod' ? appLabel : '${flavor[0].toUpperCase()}${flavor.substring(1)} $appLabel';
    ConsoleLogger.success('Created $flavor.xcconfig → Bundle ID: $bundleId, Display Name: $displayName');
  }

  ConsoleLogger.success('iOS flavor configurations created');
}

void _createAndroidStudioRunConfigs() {
  ConsoleLogger.raw('🏃 Creating Android Studio run configurations...');

  // Create .run directory
  final runDir = Directory('.run');
  if (!runDir.existsSync()) {
    runDir.createSync(recursive: true);
  }

  final flavors = ['dev', 'stage', 'prod'];

  for (final flavor in flavors) {
    final runConfigFile = File('.run/$flavor.run.xml');

    if (runConfigFile.existsSync()) {
      ConsoleLogger.warning('$flavor.run.xml already exists, skipping');
      continue;
    }

    final runConfigContent = _androidStudioRunConfigTemplate(flavor);
    runConfigFile.writeAsStringSync(runConfigContent);
    ConsoleLogger.success('Created .run/$flavor.run.xml');
  }

  ConsoleLogger.success('Android Studio run configurations created');
}
