bool isInValidArgument(String value) {
  final RegExp regex = RegExp(r'^[a-z][a-z0-9_]*$');
  return !regex.hasMatch(value);
}
