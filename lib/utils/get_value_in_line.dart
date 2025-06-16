/// get value from lines using key
String? getSingleLineValueFromLines({required List<String> lines, required String key}) {
  for (var line in lines) {
    if (line.startsWith('$key:')) {
      return line.split(':')[1].trim();
    }
  }
  return null;
}

List<String>? getMultilineValueFromLines({
  required List<String> lines,
  required String key,
}) {
  final values = <String>[];
  bool collecting = false;

  for (var line in lines) {
    if (collecting) {
      values.add(line.trim());
    }

    if (line.startsWith('$key:')) {
      collecting = true;

      // handle single-line case like: key: value
      var inlineValue = line.split(':').skip(1).join(':').trim();
      if (inlineValue.isNotEmpty) {
        values.add(inlineValue);
      }
    }
  }

  return values.isEmpty ? null : values;
}
