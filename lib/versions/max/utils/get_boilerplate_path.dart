part of '../max.dart';

/// Get the path to boilerplate templates
/// Works for both local and git activation
String _getBoilerplatePath() {
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
    '${Platform.environment['HOME']}/.pub-cache/git/sg_cli*/lib/versions/max/commands/init/boilerplate',
    // Alternative git cache locations
    '${Platform.environment['HOME']}/.pub-cache/git/cache/sg_cli*/lib/versions/max/commands/init/boilerplate',
  ];

  for (final pathPattern in possibilities) {
    final dirs = Directory(pathPattern.split('*')[0]).parent;
    if (dirs.existsSync()) {
      for (final dir in dirs.listSync()) {
        if (dir is Directory && dir.path.contains('sg_cli')) {
          final fullPath = '${dir.path}/lib/versions/max/commands/init/boilerplate';
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
  final templatePath = '${projectRoot}lib/versions/max/commands/init/boilerplate';

  if (Directory(templatePath).existsSync()) {
    return templatePath;
  }

  throw Exception('Local activation: Templates not found at $templatePath');
}

String _findBoilerplateForDirectExecution(Uri scriptUri) {
  final scriptPath = scriptUri.toFilePath();
  final scriptDir = Directory(scriptPath).parent;
  final templatePath = '${scriptDir.parent.path}/lib/versions/max/commands/init/boilerplate';

  if (Directory(templatePath).existsSync()) {
    return templatePath;
  }

  throw Exception('Direct execution: Templates not found at $templatePath');
}
