String toPascalCase(String text) {
  return text.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join('');
}

String toCamelCase(String text) {
  var words = text.split('_');
  return words.first + words.skip(1).map((word) => word[0].toUpperCase() + word.substring(1)).join('');
}
