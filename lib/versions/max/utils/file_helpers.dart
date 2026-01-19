part of '../max.dart';

/// Finds all Dart files in a directory recursively
List<File> _findDartFiles(Directory dir) {
  final dartFiles = <File>[];

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      dartFiles.add(entity);
    }
  }

  return dartFiles;
}
