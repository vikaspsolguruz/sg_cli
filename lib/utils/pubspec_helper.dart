import 'dart:io';

String getModuleName() {
  final pubspec = File('pubspec.yaml');
  if (pubspec.existsSync()) {
    final lines = pubspec.readAsLinesSync();
    for (var line in lines) {
      if (line.startsWith('name:')) {
        return line.split(':')[1].trim();
      }
    }
  }
  return '';
}