part of '../../cyan.dart';

void _initProject() {
  // Get current project name from pubspec.yaml
  _moduleName = getModuleName();

  print('${ConsoleSymbols.warning}  This will replace your current project structure with cyan architecture.\n');
  print('   📁  lib/ folder will be regenerated\n${ConsoleSymbols.package}  Dependencies will be updated');
  print('');
  stdout.write('${ConsoleSymbols.rocket} Continue with initialization? (yes/no): ');

  final String? response = stdin.readLineSync();

  if (response?.toLowerCase() != 'yes' && response?.toLowerCase() != 'y') {
    print('${ConsoleSymbols.error}  Init cancelled.');
    return;
  }

  print('');
  print('${ConsoleSymbols.loading}  Initializing cyan architecture...');

  try {
    // Step 1: Delete existing folders
    _deleteExistingFiles();

    // Step 2: Generate core architecture
    _generateCoreArchitecture();

    // Step 3: Copy assets directory
    _copyAssets();

    // Step 4: Copy test directory
    _copyTests();

    // Step 5: Replace package names in all .dart files
    _updatePackageReferences();

    // Step 6: Replace pubspec.yaml with complete configuration
    _updatePubspecDependencies();

    // Step 7: Copy other configuration files
    _generateConfigFiles();

    // Step 8: Run flutter pub get automatically
    _runPubGet();

    print('');
    print('************************************************************');
    print('*                                                          *');
    print('*                    Cyan architecture                     *');
    print('*                  initialized with a BANG!                *');
    print('*                                                          *');
    print('************************************************************');
    print('');
    print('************************************************************');
    print('*                                                          *');
    print('*                      Ready to use:                       *');
    print('*   Start creating screens with: sg create screen <name>.  *');
    print('*                                                          *');
    print('************************************************************');
    print('');
    print('************************************************************');
    print('*                                                          *');
    print('*                  🔥 🔥 🔥 🔥 🔥 🔥 🔥                   *');
    print('************************************************************');
  } catch (e) {
    print('${ConsoleSymbols.error}  Error during initialization: $e');
  }
}

void _deleteExistingFiles() {
  print('🗑️  Cleaning existing files...');

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

  // Delete analysis_options.yaml
  final analysisFile = File('analysis_options.yaml');
  if (analysisFile.existsSync()) {
    analysisFile.deleteSync();
  }
}

void _generateCoreArchitecture() {
  print('🏗️  Generating core architecture...');

  final String boilerplatePath = _getBoilerplatePath();
  final sourceLibDir = Directory('$boilerplatePath/lib');
  final targetLibDir = Directory('lib');

  if (!sourceLibDir.existsSync()) {
    throw Exception('Architecture templates not found at: $boilerplatePath/lib');
  }

  // Generate the entire lib directory
  _copyDirectory(sourceLibDir, targetLibDir);
  print('${ConsoleSymbols.success}  Generated presentation layer');
  print('${ConsoleSymbols.success}  Generated core infrastructure');
  print('${ConsoleSymbols.success}  Generated app foundation');
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
    final updatedContent = content.replaceAll('package:newarch/', 'package:$_moduleName/');

    if (content != updatedContent) {
      file.writeAsStringSync(updatedContent);
      filesUpdated++;
    }
  }

  print('${ConsoleSymbols.success}  Updated package references in $filesUpdated files');
}

void _updatePubspecDependencies() {
  print('${ConsoleSymbols.package}  Updating dependencies...');

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

  // Read boilerplate and replace name/description
  final boilerplateLines = boilerplateContent.split('\n');
  final updatedLines = <String>[];

  for (final line in boilerplateLines) {
    if (line.startsWith('name:')) {
      updatedLines.add('name: $projectName');
    } else if (line.startsWith('description:')) {
      updatedLines.add('description: "$projectDescription"');
    } else {
      updatedLines.add(line);
    }
  }

  currentPubspec.writeAsStringSync(updatedLines.join('\n'));
  print('${ConsoleSymbols.success}  Updated pubspec.yaml with dependencies, assets, and flutter config');
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
  }
}

void _generateConfigFiles() {
  final String boilerplatePath = _getBoilerplatePath();

  final boilerplateConfig = File('$boilerplatePath/sg_cli.yaml');
  final configFile = File('sg_cli.yaml');
  configFile.writeAsStringSync(boilerplateConfig.readAsStringSync());
  print('${ConsoleSymbols.success}Generated sg_cli.yaml configuration file');

  final boilerplateAnalysis = File('$boilerplatePath/analysis_options.yaml');
  final analysisFile = File('analysis_options.yaml');
  analysisFile.writeAsStringSync(boilerplateAnalysis.readAsStringSync());
  print('${ConsoleSymbols.success}Generated lints and rules');
}
