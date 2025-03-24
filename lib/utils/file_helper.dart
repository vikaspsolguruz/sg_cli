import 'dart:io';

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
    print('⚠️ File already exists: $filePath (Skipping)');
  }
}
