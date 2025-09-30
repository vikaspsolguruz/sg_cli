part of '../cyan.dart';

/// Adds a dependency to pubspec.yaml if it doesn't already exist
void _addDependencyToPubspec(String packageName, String version) {
  final pubspecFile = File('pubspec.yaml');
  
  if (!pubspecFile.existsSync()) {
    print('  ⚠️  pubspec.yaml not found');
    return;
  }
  
  var content = pubspecFile.readAsStringSync();
  
  // Check if dependency already exists
  if (content.contains('$packageName:')) {
    print('  ℹ️  $packageName already exists in pubspec.yaml');
    return;
  }
  
  // Find the dependencies section
  final dependenciesPattern = RegExp(r'^dependencies:\s*$', multiLine: true);
  final match = dependenciesPattern.firstMatch(content);
  
  if (match == null) {
    print('  ⚠️  Could not find dependencies section in pubspec.yaml');
    return;
  }
  
  // Find the next line after dependencies:
  final lines = content.split('\n');
  int dependenciesLineIndex = -1;
  
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim() == 'dependencies:') {
      dependenciesLineIndex = i;
      break;
    }
  }
  
  if (dependenciesLineIndex == -1) {
    return;
  }
  
  // Insert the new dependency after the dependencies: line
  // Find the proper indentation (usually 2 spaces)
  String indentation = '  ';
  if (dependenciesLineIndex + 1 < lines.length) {
    final nextLine = lines[dependenciesLineIndex + 1];
    if (nextLine.isNotEmpty && nextLine.startsWith(' ')) {
      // Extract indentation from next line
      final match = RegExp(r'^(\s+)').firstMatch(nextLine);
      if (match != null) {
        indentation = match.group(1)!;
      }
    }
  }
  
  // Insert the new dependency
  lines.insert(dependenciesLineIndex + 1, '$indentation$packageName: $version');
  
  content = lines.join('\n');
  pubspecFile.writeAsStringSync(content);
  
  print('  ✓ Added $packageName: $version to pubspec.yaml');
}
