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
    // Step 1: Delete existing lib folder
    _deleteExistingFiles();

    // Step 2: Generate core architecture
    _generateCoreArchitecture();

    // Step 3: Replace package names in all .dart files
    _updatePackageReferences();

    // Step 4: Replace pubspec.yaml dependencies
    _updatePubspecDependencies();

    // Step 5: Copy other configuration files
    _generateConfigFiles();

    // Step 6: Run flutter pub get automatically
    _runPubGet();

    print('');
    print('✅  Cyan architecture initialized successfully!');
    print('');
    print('📝  Ready to use:');
    print('• Start creating screens with: sg create screen <name>');
    print('');
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
  print('🔗  Updating package references...');

  final libDir = Directory('lib');
  final dartFiles = _findDartFiles(libDir);

  int filesUpdated = 0;

  for (final file in dartFiles) {
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
  print('✅  Updated pubspec.yaml with fresh dependencies');
}

void _generateConfigFiles() {
  print('⚙️  Generating configuration files...');

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
  // Find the boilerplate folder relative to where this script is actually located
  // Platform.script gives us the URI of the currently running script

  final scriptUri = Platform.script;
  final scriptPath = scriptUri.toFilePath();
  final scriptDir = Directory(scriptPath).parent;

  final possibilities = [
    // For pub global activated: navigate from .dart_tool/pub/bin/sg_cli back to package root
    '${scriptDir.parent.parent.parent.parent.path}/lib/versions/cyan/commands/init/boilerplate',
    // Try relative to the script location (for development/local setup)
    '${scriptDir.path}/lib/versions/cyan/commands/init/boilerplate',
    // Try from the package root if script is in bin/
    '${scriptDir.parent.path}/lib/versions/cyan/commands/init/boilerplate',
    // Try if we're running from a pub global activated package (alternative path)
    '${scriptDir.parent.parent.path}/lib/versions/cyan/commands/init/boilerplate',
    // Final fallback - try relative to current working directory
    '${Directory.current.path}/lib/versions/cyan/commands/init/boilerplate',
  ];

  for (final path in possibilities) {
    final boilerplateDir = Directory(path);
    if (boilerplateDir.existsSync()) {
      return path;
    }
  }

  // Debug: Show what paths we tried
  print('🔍  Searched paths:');
  for (final path in possibilities) {
    print('    - $path');
  }

  throw Exception('Architecture templates not found. Make sure sg_cli is properly installed.');
}

void _copyDirectory(Directory source, Directory target) {
  if (!target.existsSync()) {
    target.createSync(recursive: true);
  }

  for (final entity in source.listSync()) {
    final entityName = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;

    if (entity is File) {
      final targetFile = File('${target.path}/$entityName');
      entity.copySync(targetFile.path);
    } else if (entity is Directory) {
      final targetDir = Directory('${target.path}/$entityName');
      _copyDirectory(entity, targetDir);
    }
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
