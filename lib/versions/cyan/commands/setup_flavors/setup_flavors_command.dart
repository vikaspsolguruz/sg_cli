part of '../../cyan.dart';

void _setupFlavors() {
  print('');
  print('🎨 Setting up Flutter flavors (dev, stage, prod)...');
  print('');

  // Validate cyan config exists
  if (!_validateCyanConfig()) {
    return;
  }

  try {
    final projectName = getModuleName();
    final packageName = _getBasePackageId();

    print('📦 Project: $projectName');
    print('🆔 Package ID: $packageName');
    print('');

    print('🔍 Detecting build configuration file...');

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

    // Add product flavors
    _addProductFlavors(buildFile, isKotlinDsl, projectName);

    // Create flavor directories
    _createFlavorDirectories();
    
    // Create iOS flavor configurations
    _createIOSFlavorConfigs(packageName);

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

bool _validateCyanConfig() {
  final configFile = File('sg_cli.yaml');

  if (!configFile.existsSync()) {
    print('${ConsoleSymbols.error} Error: sg_cli.yaml not found!');
    print('   This command only works with cyan architecture projects.');
    print('   Run: sg init');
    return false;
  }

  final content = configFile.readAsStringSync();
  if (!content.contains('version: cyan')) {
    print('${ConsoleSymbols.error} Error: This command only works with cyan architecture.');
    print('   Current config is not cyan version.');
    return false;
  }

  return true;
}

void _addProductFlavors(File buildFile, bool isKotlinDsl, String projectName) {
  var content = buildFile.readAsStringSync();

  // Check if flavors already exist
  if (content.contains('flavorDimensions')) {
    print('⚠️  Product flavors already exist in ${buildFile.path.split('/').last}');
    print('   Skipping flavor configuration...');
    return;
  }

  print('📝 Adding product flavors to ${buildFile.path.split('/').last}...');

  String flavorConfig;

  if (isKotlinDsl) {
    // Kotlin DSL syntax
    flavorConfig = '''

    flavorDimensions += "app"
    productFlavors {
        create("dev") {
            dimension = "app"
            resValue("string", "app_name", "Dev $projectName")
            versionNameSuffix = "-dev"
            applicationIdSuffix = ".dev"
        }
        create("stage") {
            dimension = "app"
            resValue("string", "app_name", "Stage $projectName")
            versionNameSuffix = "-stage"
            applicationIdSuffix = ".stage"
        }
        create("prod") {
            dimension = "app"
            resValue("string", "app_name", "$projectName")
        }
    }
''';
  } else {
    // Groovy syntax
    flavorConfig = '''

    flavorDimensions "app"
    productFlavors {
        dev {
            dimension "app"
            resValue "string", "app_name", "Dev $projectName"
            versionNameSuffix "-dev"
            applicationIdSuffix ".dev"
        }
        stage {
            dimension "app"
            resValue "string", "app_name", "Stage $projectName"
            versionNameSuffix "-stage"
            applicationIdSuffix ".stage"
        }
        prod {
            dimension "app"
            resValue "string", "app_name", "$projectName"
        }
    }
''';
  }

  // Find the closing brace of android block
  final androidBlockEnd = content.lastIndexOf('}');

  if (androidBlockEnd == -1) {
    throw Exception('Could not find android block in ${buildFile.path.split('/').last}');
  }

  // Insert before the closing brace
  content = content.substring(0, androidBlockEnd) + flavorConfig + '\n' + content.substring(androidBlockEnd);

  buildFile.writeAsStringSync(content);
  print('✓ Product flavors added successfully');
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

void _createIOSFlavorConfigs(String packageName) {
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
    
    final xcconfigContent = _iosXcconfigTemplate(flavor, packageName);
    xcconfigFile.writeAsStringSync(xcconfigContent);
    
    final bundleId = flavor == 'prod' ? packageName : '$packageName.$flavor';
    print('  ✓ Created $flavor.xcconfig → Bundle ID: $bundleId');
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
