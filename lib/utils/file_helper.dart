import 'dart:io';

import 'package:sg_cli/utils/console_logger.dart';

void createDirectory(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
}

void createFile(String filePath, String content) {
  final file = File(filePath);
  if (!file.existsSync()) {
    file.writeAsStringSync(content);
  } else {
    ConsoleLogger.warning('File already exists: $filePath (Skipping)');
  }
}
