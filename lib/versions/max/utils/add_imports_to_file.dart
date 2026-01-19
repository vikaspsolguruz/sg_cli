part of '../max.dart';

/// Adds import statements to a file if they don't already exist
void _addImportsToFile(File file, List<String> imports) {
  if (!file.existsSync()) {
    print('${ConsoleSymbols.warning}  File not found: ${file.path}');
    return;
  }

  var content = file.readAsStringSync();
  var lines = content.split('\n');
  
  // Find the last import statement index
  int lastImportIndex = -1;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().startsWith('import ')) {
      lastImportIndex = i;
    }
  }
  
  // Add new imports after the last import
  List<String> newImports = [];
  for (final import in imports) {
    if (!content.contains(import)) {
      newImports.add(import);
    }
  }
  
  if (newImports.isEmpty) {
    return;
  }
  
  // Insert new imports
  if (lastImportIndex >= 0) {
    lines.insertAll(lastImportIndex + 1, newImports);
  } else {
    // No imports exist, add at the beginning
    lines.insertAll(0, newImports);
  }
  
  file.writeAsStringSync(lines.join('\n'));
  
  for (final import in newImports) {
    print('${ConsoleSymbols.checkmark} Added import: $import');
  }
}
