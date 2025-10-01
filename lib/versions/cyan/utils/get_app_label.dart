part of '../cyan.dart';

/// Extracts the app label from AndroidManifest.xml
/// Handles both direct label strings and @string/app_name references
String _getAppLabel() {
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  
  if (!manifestFile.existsSync()) {
    print('${ConsoleSymbols.warning} AndroidManifest.xml not found, using fallback');
    return 'App';
  }

  final manifestContent = manifestFile.readAsStringSync();
  
  // Find android:label in application tag
  final labelPattern = RegExp(r'<application[^>]*android:label="([^"]+)"');
  final labelMatch = labelPattern.firstMatch(manifestContent);
  
  if (labelMatch == null) {
    print('${ConsoleSymbols.warning} Could not find android:label in AndroidManifest.xml');
    return 'App';
  }

  final labelValue = labelMatch.group(1)!;
  
  // Check if it's a string resource reference like @string/app_name
  if (labelValue.startsWith('@string/')) {
    final stringKey = labelValue.replaceFirst('@string/', '');
    return _extractStringResource(stringKey);
  }
  
  // It's a direct label
  return labelValue;
}

/// Extracts a string resource from strings.xml
String _extractStringResource(String key) {
  final stringsFile = File('android/app/src/main/res/values/strings.xml');
  
  if (!stringsFile.existsSync()) {
    print('${ConsoleSymbols.warning} strings.xml not found, using key as fallback');
    return key;
  }

  final stringsContent = stringsFile.readAsStringSync();
  
  // Find the string resource: <string name="app_name">MyApp</string>
  final stringPattern = RegExp('<string[^>]*name="$key"[^>]*>([^<]+)</string>');
  final stringMatch = stringPattern.firstMatch(stringsContent);
  
  if (stringMatch == null) {
    print('${ConsoleSymbols.warning} String resource "$key" not found in strings.xml');
    return key;
  }

  return stringMatch.group(1)!.trim();
}
