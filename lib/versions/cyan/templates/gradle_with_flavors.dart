part of '../cyan.dart';

void _addProductFlavors(File buildFile, bool isKotlinDsl, String projectName) {
  var content = buildFile.readAsStringSync();

  // Check if flavors already exist
  if (content.contains('flavorDimensions')) {
    print('⚠️  Product flavors already exist in ${buildFile.path.split('/').last}');
    print('   Skipping flavor configuration...');
    return;
  }

  print('📝 Adding product flavors to ${buildFile.path.split('/').last}...');

  String flavorConfig;

  if (isKotlinDsl) {
    // Kotlin DSL syntax
    flavorConfig =
        '''

    flavorDimensions += "app"
    productFlavors {
        create("dev") {
            dimension = "app"
            resValue("string", "app_name", "Dev $projectName")
            versionNameSuffix = "-dev"
            applicationIdSuffix = ".dev"
        }
        create("stage") {
            dimension = "app"
            resValue("string", "app_name", "Stage $projectName")
            versionNameSuffix = "-stage"
            applicationIdSuffix = ".stage"
        }
        create("prod") {
            dimension = "app"
            resValue("string", "app_name", "$projectName")
        }
    }
''';
  } else {
    // Groovy syntax
    flavorConfig =
        '''

    flavorDimensions "app"
    productFlavors {
        dev {
            dimension "app"
            resValue "string", "app_name", "Dev $projectName"
            versionNameSuffix "-dev"
            applicationIdSuffix ".dev"
        }
        stage {
            dimension "app"
            resValue "string", "app_name", "Stage $projectName"
            versionNameSuffix "-stage"
            applicationIdSuffix ".stage"
        }
        prod {
            dimension "app"
            resValue "string", "app_name", "$projectName"
        }
    }
''';
  }

  // Find the android block and its closing brace
  final androidPattern = RegExp(r'android\s*\{');
  final androidMatch = androidPattern.firstMatch(content);

  if (androidMatch == null) {
    throw Exception('Could not find android block in ${buildFile.path.split('/').last}');
  }

  // Start after "android {"
  int startPos = androidMatch.end;
  int braceCount = 1; // We already have one opening brace from "android {"
  int androidBlockEnd = -1;

  // Count braces to find the matching closing brace for android block
  for (int i = startPos; i < content.length; i++) {
    if (content[i] == '{') {
      braceCount++;
    } else if (content[i] == '}') {
      braceCount--;
      if (braceCount == 0) {
        androidBlockEnd = i;
        break;
      }
    }
  }

  if (androidBlockEnd == -1) {
    throw Exception('Could not find closing brace for android block in ${buildFile.path.split('/').last}');
  }

  // Insert before the closing brace of android block
  content = '${content.substring(0, androidBlockEnd)}$flavorConfig\n${content.substring(androidBlockEnd)}';

  buildFile.writeAsStringSync(content);
  print('✓ Product flavors added successfully');
}
