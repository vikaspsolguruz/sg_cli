part of '../max.dart';

/// Extracts project name from pubspec.yaml lines
String _extractProjectName(List<String> lines) {
  for (final line in lines) {
    if (line.trim().startsWith('name:')) {
      return line.split(':')[1].trim();
    }
  }
  return 'flutter_app'; // fallback
}

/// Extracts project description from pubspec.yaml lines
String _extractProjectDescription(List<String> lines) {
  for (final line in lines) {
    if (line.trim().startsWith('description:')) {
      final desc = line.split(':')[1].trim();
      return desc.replaceAll('"', '').replaceAll("'", '');
    }
  }
  return 'A new Flutter project.'; // fallback
}
