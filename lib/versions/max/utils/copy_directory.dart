part of '../max.dart';

/// Recursively copies a directory from source to target
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
