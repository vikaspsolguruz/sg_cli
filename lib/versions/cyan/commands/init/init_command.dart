part of '../../cyan.dart';

void _initProject() {
  // Get current project name from pubspec.yaml
  _moduleName = getModuleName();

  print('⚠️  This will replace your current project structure with cyan architecture.\n');
  print('   📁  lib/ folder will be regenerated\n   📦  Dependencies will be updated');
  print('');
  stdout.write('🚀 Continue with initialization? (yes/no): ');

  final String? response = stdin.readLineSync();

  if (response?.toLowerCase() != 'yes' && response?.toLowerCase() != 'y') {
    print('❌  Init cancelled.');
    return;
  }

  print('');
  print('🔄  Initializing cyan architecture...');

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
    print('❌  Error during initialization: $e');
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

  final String boilerplatePath = getBoilerplatePath();
  final sourceLibDir = Directory('$boilerplatePath/lib');
  final targetLibDir = Directory('lib');

  if (!sourceLibDir.existsSync()) {
    throw Exception('Architecture templates not found at: $boilerplatePath/lib');
  }

  // Generate the entire lib directory
  _copyDirectory(sourceLibDir, targetLibDir);
  print('✅  Generated presentation layer');
  print('✅  Generated core infrastructure');
  print('✅  Generated app foundation');
}

void _updatePackageReferences() {
  final libDir = Directory('lib');
  final testDir = Directory('test');
  
  // Collect all Dart files from both lib and test directories
  final libFiles = _findDartFiles(libDir);
  final testFiles = testDir.existsSync() ? _findDartFiles(testDir) : <File>[];
  final allDartFiles = [...libFiles, ...testFiles];

  int filesUpdated = 0;

  for (final file in allDartFiles) {
    final content = file.readAsStringSync();
    final updatedContent = content.replaceAll('package:newarch/', 'package:$_moduleName/');

    if (content != updatedContent) {
      file.writeAsStringSync(updatedContent);
      filesUpdated++;
    }
  }

  print('✅  Updated package references in $filesUpdated files');
}

void _updatePubspecDependencies() {
  print('📦  Updating dependencies...');

  final String boilerplatePath = getBoilerplatePath();
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
  print('✅  Updated pubspec.yaml with dependencies, assets, and flutter config');
}

void _copyAssets() {
  final String boilerplatePath = getBoilerplatePath();
  final sourceAssetsDir = Directory('$boilerplatePath/assets');
  final targetAssetsDir = Directory('assets');

  if (sourceAssetsDir.existsSync()) {
    _copyDirectory(sourceAssetsDir, targetAssetsDir);
    print('✅  Generated assets');
  } else {
    print('⚠️  No assets found in boilerplate');
  }
}

void _copyTests() {
  final String boilerplatePath = getBoilerplatePath();
  final sourceTestDir = Directory('$boilerplatePath/test');
  final targetTestDir = Directory('test');

  if (sourceTestDir.existsSync()) {
    _copyDirectory(sourceTestDir, targetTestDir);
    print('✅  Generated test');
  } else {
    print('⚠️  No tests found in boilerplate');
  }
}

void _generateConfigFiles() {
  final String boilerplatePath = getBoilerplatePath();

  // Generate analysis_options.yaml
  final sourceAnalysis = File('$boilerplatePath/analysis_options.yaml');
  final targetAnalysis = File('analysis_options.yaml');
  if (sourceAnalysis.existsSync()) {
    sourceAnalysis.copySync(targetAnalysis.path);
    print('✅  Updated lints and rules');
  }

  // Generate .editorconfig
  final sourceEditor = File('$boilerplatePath/.editorconfig');
  final targetEditor = File('.editorconfig');
  if (sourceEditor.existsSync()) {
    sourceEditor.copySync(targetEditor.path);
    print('✅  Generated editor configuration');
  }

  // Generate sg_cli.yaml only if it doesn't exist
  final targetSgCli = File('sg_cli.yaml');
  if (!targetSgCli.existsSync()) {
    final sourceSgCli = File('$boilerplatePath/sg_cli.yaml');
    if (sourceSgCli.existsSync()) {
      sourceSgCli.copySync(targetSgCli.path);
      print('✅  Generated sg_cli configuration');
    }
  }
}

void _runPubGet() {
  print('📦  Installing dependencies...');

  try {
    final result = Process.runSync('flutter', ['pub', 'get']);

    if (result.exitCode == 0) {
      print('✅  Dependencies installed successfully');
    } else {
      print('⚠️  Warning: Failed to install dependencies automatically');
      print('   Please run: flutter pub get');
    }
  } catch (e) {
    print('⚠️  Warning: Failed to install dependencies automatically');
    print('   Please run: flutter pub get');
  }
}

// Helper functions
String getBoilerplatePath() {
  // Smart path resolution that works for both local and git activation
  final scriptUri = Platform.script;

  // Different strategies based on how the CLI was activated
  if (scriptUri.toString().contains('.pub-cache/global_packages/sg_cli')) {
    // Git activation - try to find the actual source repository
    return _findBoilerplateForGitActivation();
  } else if (scriptUri.toString().contains('.dart_tool/pub/bin')) {
    // Local activation - navigate from .dart_tool back to project root
    return _findBoilerplateForLocalActivation(scriptUri);
  } else {
    // Direct execution from bin/ directory
    return _findBoilerplateForDirectExecution(scriptUri);
  }
}

String _findBoilerplateForGitActivation() {
  // For git activation, the templates should be in the downloaded git source
  // Since lib/ isn't cached, we need to find where git downloaded the source

  // Try to find git source in common locations
  final possibilities = [
    // In user's home .pub-cache/git/ directory
    '${Platform.environment['HOME']}/.pub-cache/git/sg_cli*/lib/versions/cyan/commands/init/boilerplate',
    // Alternative git cache locations
    '${Platform.environment['HOME']}/.pub-cache/git/cache/sg_cli*/lib/versions/cyan/commands/init/boilerplate',
  ];

  for (final pathPattern in possibilities) {
    final dirs = Directory(pathPattern.split('*')[0]).parent;
    if (dirs.existsSync()) {
      for (final dir in dirs.listSync()) {
        if (dir is Directory && dir.path.contains('sg_cli')) {
          final fullPath = '${dir.path}/lib/versions/cyan/commands/init/boilerplate';
          if (Directory(fullPath).existsSync()) {
            return fullPath;
          }
        }
      }
    }
  }

  throw Exception('Git activation: Cannot find sg_cli source templates. This is a known limitation - please use local activation for init command.');
}

String _findBoilerplateForLocalActivation(Uri scriptUri) {
  final scriptPath = scriptUri.toFilePath();
  final projectRoot = scriptPath.split('.dart_tool')[0];
  final templatePath = '${projectRoot}lib/versions/cyan/commands/init/boilerplate';

  if (Directory(templatePath).existsSync()) {
    return templatePath;
  }

  throw Exception('Local activation: Templates not found at $templatePath');
}

String _findBoilerplateForDirectExecution(Uri scriptUri) {
  final scriptPath = scriptUri.toFilePath();
  final scriptDir = Directory(scriptPath).parent;
  final templatePath = '${scriptDir.parent.path}/lib/versions/cyan/commands/init/boilerplate';

  if (Directory(templatePath).existsSync()) {
    return templatePath;
  }

  throw Exception('Direct execution: Templates not found at $templatePath');
}

void _copyDirectory(Directory source, Directory target) {
  if (!target.existsSync()) {
    target.createSync(recursive: true);
  }

  try {
    for (final entity in source.listSync()) {
      final entityName = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;

      if (entity is File) {
        final targetFile = File('${target.path}/$entityName');
        // Ensure target directory exists before copying file
        targetFile.parent.createSync(recursive: true);
        
        try {
          entity.copySync(targetFile.path);
        } catch (e) {
          // Handle 0-byte files or other file copy issues
          print('⚠️  Warning: Could not copy ${entity.path}: $e');
          // Create the file anyway to preserve directory structure
          targetFile.createSync();
        }
      } else if (entity is Directory) {
        final targetDir = Directory('${target.path}/$entityName');
        _copyDirectory(entity, targetDir);
      }
    }
  } catch (e) {
    print('⚠️  Warning: Error copying from ${source.path}: $e');
  }
}

List<File> _findDartFiles(Directory dir) {
  final dartFiles = <File>[];

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      dartFiles.add(entity);
    }
  }

  return dartFiles;
}

String _extractProjectName(List<String> lines) {
  for (final line in lines) {
    if (line.trim().startsWith('name:')) {
      return line.split(':')[1].trim();
    }
  }
  return 'flutter_app'; // fallback
}

String _extractProjectDescription(List<String> lines) {
  for (final line in lines) {
    if (line.trim().startsWith('description:')) {
      final desc = line.split(':')[1].trim();
      return desc.replaceAll('"', '').replaceAll("'", '');
    }
  }
  return 'A new Flutter project.'; // fallback
}
