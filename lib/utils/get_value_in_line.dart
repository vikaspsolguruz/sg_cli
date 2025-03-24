/// get value from lines using key
String? getValueFromLines({required List<String> lines, required String key}) {
  for (var line in lines) {
    if (line.startsWith('$key:')) {
      return line.split(':')[1].trim();
    }
  }
  return null;
}
