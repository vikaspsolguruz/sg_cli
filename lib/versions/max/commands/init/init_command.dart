part of '../../max.dart';

void _initProject() {
  // Get current project name from pubspec.yaml
  _moduleName = getModuleName();

  ConsoleLogger.warning('This will replace your current project structure with max architecture.');
  ConsoleLogger.raw(' ❒  lib/ folder will be regenerated');
  ConsoleLogger.info('Dependencies will be updated');
  ConsoleLogger.blank();
  stdout.write('${ConsoleSymbols.rocket} Continue with initialization? (yes/no): ');

  final String? response = stdin.readLineSync();

  if (response?.toLowerCase() != 'yes' && response?.toLowerCase() != 'y') {
    ConsoleLogger.error('Init cancelled.');
    return;
  }

  ConsoleLogger.blank();
  ConsoleLogger.loading('Initializing max architecture...');

  try {
    // Step 1: Delete existing folders
    _deleteExistingFiles();

    // Step 2: Generate core architecture
    _generateCoreArchitecture();

    // Step 3: Copy assets directory
    _copyAssets();

    // Step 4: Copy test directory
    _copyTests();

    // Step 5: Copy integration_test directory
    _copyIntegrationTests();

    // Step 6: Setup Patrol native configuration
    _setupPatrolNative();

    // Step 7: Replace package names in all .dart files
    _updatePackageReferences();

    // Step 7: Replace pubspec.yaml with complete configuration
    _updatePubspecDependencies();

    // Step 8: Copy other configuration files
    _generateConfigFiles();

    // Step 9: Run flutter pub get automatically
    _runPubGet();

    ConsoleLogger.blank();
    ConsoleLogger.banner('                    Max architecture                      ', subtitle: '                  initialized with a BANG!                ');
    ConsoleLogger.blank();
    ConsoleLogger.banner('                      Ready to use:                       ', subtitle: '   Start creating screens with: sg create screen <name>.  ');
    ConsoleLogger.blank();
    ConsoleLogger.banner('                  🔥 🔥 🔥 🔥 🔥 🔥 🔥                           ');
    ConsoleLogger.blank();
  } catch (e) {
    ConsoleLogger.error('Initialization failed: $e');
  }
}

void _deleteExistingFiles() {
  ConsoleLogger.raw('🗑️  Cleaning existing files...');

  // Delete lib folder
  final libDir = Directory('lib');
  if (libDir.existsSync()) {
    libDir.deleteSync(recursive: true);
  }

  // Delete assets folder
  final assetsDir = Directory('assets');
  if (assetsDir.existsSync()) {
    assetsDir.deleteSync(recursive: true);
  }

  // Delete test folder
  final testDir = Directory('test');
  if (testDir.existsSync()) {
    testDir.deleteSync(recursive: true);
  }

  // Delete integration_test folder
  final integrationTestDir = Directory('integration_test');
  if (integrationTestDir.existsSync()) {
    integrationTestDir.deleteSync(recursive: true);
  }

  // Delete analysis_options.yaml
  final analysisFile = File('analysis_options.yaml');
  if (analysisFile.existsSync()) {
    analysisFile.deleteSync();
  }
}

void _generateCoreArchitecture() {
  ConsoleLogger.raw('🏗️  Generating core architecture...');

  final String boilerplatePath = _getBoilerplatePath();
  final sourceLibDir = Directory('$boilerplatePath/lib');
  final targetLibDir = Directory('lib');

  if (!sourceLibDir.existsSync()) {
    throw Exception('Architecture templates not found at: $boilerplatePath/lib');
  }

  // Generate the entire lib directory
  _copyDirectory(sourceLibDir, targetLibDir);
  ConsoleLogger.success('Generated presentation layer');
  ConsoleLogger.success('Generated core infrastructure');
  ConsoleLogger.success('Generated app foundation');
}

void _updatePackageReferences() {
  final pubspecFile = File('pubspec.yaml');
  final pubspecLines = pubspecFile.readAsLinesSync();

  final oldProjectName = _extractProjectName(pubspecLines);
  final projectDescription = _extractProjectDescription(pubspecLines);

  _moduleName = getModuleName();

  // Find all Dart files
  final dartFiles = _findDartFiles(Directory('lib'));

  int filesUpdated = 0;

  for (final file in dartFiles) {
    final content = file.readAsStringSync();
    final updatedContent = content.replaceAll('package:max_arch/', 'package:$_moduleName/');

    if (content != updatedContent) {
      file.writeAsStringSync(updatedContent);
      filesUpdated++;
    }
  }

  ConsoleLogger.success('Updated package references in $filesUpdated files');
}

void _updatePubspecDependencies() {
  ConsoleLogger.info('Updating dependencies...');

  final String boilerplatePath = _getBoilerplatePath();
  final boilerplatePubspec = File('$boilerplatePath/pubspec.yaml');
  final currentPubspec = File('pubspec.yaml');

  if (!boilerplatePubspec.existsSync()) {
    throw Exception('Dependency template not found');
  }

  if (!currentPubspec.existsSync()) {
    throw Exception('Current pubspec.yaml not found');
  }

  // Read boilerplate dependencies
  final boilerplateContent = boilerplatePubspec.readAsStringSync();
  final currentContent = currentPubspec.readAsStringSync();

  // Extract project info from current pubspec
  final currentLines = currentContent.split('\n');
  final projectName = _extractProjectName(currentLines);
  final projectDescription = _extractProjectDescription(currentLines);
  
  // Extract app label and package ID for patrol configuration
  final appLabel = _getAppLabel();
  final packageId = _getBasePackageId();

  // Read boilerplate and replace name/description/patrol config
  final boilerplateLines = boilerplateContent.split('\n');
  final updatedLines = <String>[];
  
  bool inPatrolSection = false;

  for (final line in boilerplateLines) {
    if (line.startsWith('name:')) {
      updatedLines.add('name: $projectName');
    } else if (line.startsWith('description:')) {
      updatedLines.add('description: "$projectDescription"');
    } else if (line.trim().startsWith('patrol:')) {
      // Entering patrol section
      inPatrolSection = true;
      updatedLines.add(line);
    } else if (inPatrolSection) {
      // Replace patrol configuration values while preserving indentation
      if (line.contains('app_name:')) {
        final indent = line.substring(0, line.indexOf('app_name:'));
        updatedLines.add('${indent}app_name: $appLabel');
      } else if (line.contains('package_name:')) {
        final indent = line.substring(0, line.indexOf('package_name:'));
        updatedLines.add('${indent}package_name: $packageId');
      } else if (line.contains('bundle_id:')) {
        final indent = line.substring(0, line.indexOf('bundle_id:'));
        updatedLines.add('${indent}bundle_id: $packageId');
      } else {
        updatedLines.add(line);
        // Exit patrol section if we hit a line that's not indented or starts a new section
        if (line.trim().isNotEmpty && !line.startsWith(' ') && !line.startsWith('\t')) {
          inPatrolSection = false;
        }
      }
    } else {
      updatedLines.add(line);
    }
  }

  currentPubspec.writeAsStringSync(updatedLines.join('\n'));
  ConsoleLogger.success('Updated pubspec.yaml with dependencies, assets, and flutter config');
  ConsoleLogger.success('Configured Patrol with app: $appLabel, package: $packageId');
}

void _copyAssets() {
  final assetsSource = Directory('${_getBoilerplatePath()}/assets');
  final assetsTarget = Directory('assets');

  if (assetsSource.existsSync()) {
    _copyDirectory(assetsSource, assetsTarget);
  }
}

void _copyTests() {
  final testsSource = Directory('${_getBoilerplatePath()}/test');
  final testsTarget = Directory('test');

  if (testsSource.existsSync()) {
    _copyDirectory(testsSource, testsTarget);

    final testFiles = _findDartFiles(testsTarget);
    int filesUpdated = 0;

    for (final file in testFiles) {
      final content = file.readAsStringSync();
      final updatedContent = content.replaceAll('package:max_arch/', 'package:$_moduleName/');

      if (content != updatedContent) {
        file.writeAsStringSync(updatedContent);
        filesUpdated++;
      }
    }

    if (filesUpdated > 0) {
      ConsoleLogger.success('Updated package references in $filesUpdated test files');
    }
  }
}

void _copyIntegrationTests() {
  ConsoleLogger.raw('🧪  Copying integration tests...');
  
  final integrationTestsSource = Directory('${_getBoilerplatePath()}/integration_test');
  final integrationTestsTarget = Directory('integration_test');

  if (integrationTestsSource.existsSync()) {
    _copyDirectory(integrationTestsSource, integrationTestsTarget);

    final testFiles = _findDartFiles(integrationTestsTarget);
    int filesUpdated = 0;

    for (final file in testFiles) {
      final content = file.readAsStringSync();
      final updatedContent = content.replaceAll('package:max_arch/', 'package:$_moduleName/');

      if (content != updatedContent) {
        file.writeAsStringSync(updatedContent);
        filesUpdated++;
      }
    }

    if (filesUpdated > 0) {
      ConsoleLogger.success('Updated package references in $filesUpdated integration test files');
    }
  } else {
    ConsoleLogger.warning('Integration test directory not found in boilerplate');
  }
}

void _generateConfigFiles() {
  final String boilerplatePath = _getBoilerplatePath();

  final boilerplateConfig = File('$boilerplatePath/sg_cli.yaml');
  final configFile = File('sg_cli.yaml');
  configFile.createSync();
  configFile.writeAsStringSync(boilerplateConfig.readAsStringSync());
  ConsoleLogger.success('Generated sg_cli.yaml configuration file');

  final boilerplateAnalysis = File('$boilerplatePath/analysis_options.yaml');
  final analysisFile = File('analysis_options.yaml');
  analysisFile.createSync();
  analysisFile.writeAsStringSync(boilerplateAnalysis.readAsStringSync());
  ConsoleLogger.success('Generated lints and rules');

  final boilerplateEditorConfig = File('$boilerplatePath/.editorconfig');
  final editorFile = File('.editorconfig');
  editorFile.createSync();
  editorFile.writeAsStringSync(boilerplateEditorConfig.readAsStringSync());
  ConsoleLogger.success('Generated editor configs');

  final boilerplateDevtools = File('$boilerplatePath/devtools_options.yaml');
  if (boilerplateDevtools.existsSync()) {
    final devtoolsFile = File('devtools_options.yaml');
    devtoolsFile.createSync();
    devtoolsFile.writeAsStringSync(boilerplateDevtools.readAsStringSync());
    ConsoleLogger.success('Generated DevTools configuration');
  }
}
