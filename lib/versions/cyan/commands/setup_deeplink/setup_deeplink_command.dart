part of '../../cyan.dart';

void _setupDeeplink() {
  print('');
  print('${ConsoleSymbols.link} Setting up deep-linking for flavors...');
  print('');

  // Validate cyan config exists
  if (!_validateCyanConfig()) {
    return;
  }

  try {
    // Check if flavors exist
    if (!_checkFlavorsExist()) {
      print('${ConsoleSymbols.error} Error: Product flavors not found!');
      print('   Please run: sg setup_flavors first');
      return;
    }

    print('${ConsoleSymbols.note} Please provide deep-link domains for each flavor:');
    print('');

    // Get domains for each flavor
    stdout.write('🔸 Dev domain (e.g., myapp-dev.example.com): ');
    final devDomain = stdin.readLineSync()?.trim() ?? '';

    stdout.write('🔸 Stage domain (e.g., myapp-stage.example.com): ');
    final stageDomain = stdin.readLineSync()?.trim() ?? '';

    stdout.write('🔸 Prod domain (e.g., myapp.example.com): ');
    final prodDomain = stdin.readLineSync()?.trim() ?? '';

    if (devDomain.isEmpty || stageDomain.isEmpty || prodDomain.isEmpty) {
      print('${ConsoleSymbols.error} All domains are required!');
      return;
    }

    print('');
    print('${ConsoleSymbols.rocket} Configuring deep-linking...');
    print('');

    final domains = {
      'dev': devDomain,
      'stage': stageDomain,
      'prod': prodDomain,
    };

    // Setup Android deep-linking
    _setupAndroidDeeplink(domains);

    // Setup iOS deep-linking
    _setupIOSDeeplink(domains);

    // Setup Flutter deep-link handling
    _setupFlutterDeepLink();

    print('');
    print('╔════════════════════════════════════════════════════════════════════════════════╗');
    print('║                ${ConsoleSymbols.success} Deep-Linking Setup Complete!                             ║');
    print('╚════════════════════════════════════════════════════════════════════════════════╝');
    print('');
    print('${ConsoleSymbols.mobile} Android Configuration:');
    print('   ${ConsoleSymbols.checkmark} Created AndroidManifest.xml for each flavor');
    print('     • android/app/src/dev/AndroidManifest.xml → $devDomain');
    print('     • android/app/src/stage/AndroidManifest.xml → $stageDomain');
    print('     • android/app/src/prod/AndroidManifest.xml → $prodDomain');
    print('');
    print('${ConsoleSymbols.apple} iOS Configuration:');
    print('   ${ConsoleSymbols.checkmark} Created entitlements for each flavor');
    print('     • ios/Runner/Runner-dev.entitlements → applinks:$devDomain');
    print('     • ios/Runner/Runner-stage.entitlements → applinks:$stageDomain');
    print('     • ios/Runner/Runner-prod.entitlements → applinks:$prodDomain');
    print('');
    print('${ConsoleSymbols.warning}  iOS Xcode Configuration Required:');
    print('   1. Open ios/Runner.xcworkspace in Xcode');
    print('   2. Select Runner target → Build Settings');
    print('   3. Search for "Code Signing Entitlements"');
    print('   4. Set entitlements per configuration:');
    print('      • Debug-dev: Runner/Runner-dev.entitlements');
    print('      • Debug-stage: Runner/Runner-stage.entitlements');
    print('      • Release: Runner/Runner-prod.entitlements');
    print('');
    print('${ConsoleSymbols.globe} Domain Verification:');
    print('   Don\'t forget to upload apple-app-site-association file to:');
    print('   • https://$devDomain/.well-known/apple-app-site-association');
    print('   • https://$stageDomain/.well-known/apple-app-site-association');
    print('   • https://$prodDomain/.well-known/apple-app-site-association');
    print('');
  } catch (e) {
    print('${ConsoleSymbols.error} Error during deep-link setup: $e');
  }
}

bool _checkFlavorsExist() {
  final devDir = Directory('android/app/src/dev');
  final stageDir = Directory('android/app/src/stage');
  final prodDir = Directory('android/app/src/prod');

  return devDir.existsSync() && stageDir.existsSync() && prodDir.existsSync();
}

void _setupAndroidDeeplink(Map<String, String> domains) {
  print('${ConsoleSymbols.robot} Configuring Android deep-linking...');

  for (final flavor in domains.keys) {
    final domain = domains[flavor]!;
    _createAndroidManifest(flavor, domain);
  }

  print('${ConsoleSymbols.checkmark} Android deep-linking configured');
}

void _createAndroidManifest(String flavor, String domain) {
  final manifestFile = File('android/app/src/$flavor/AndroidManifest.xml');

  if (manifestFile.existsSync()) {
    print('${ConsoleSymbols.warning} AndroidManifest.xml already exists for $flavor, skipping...');
    return;
  }

  // Create directory if it doesn't exist
  manifestFile.parent.createSync(recursive: true);

  // Use the template function
  final manifestContent = _deeplinkAndroidManifestTemplate(domain);

  manifestFile.writeAsStringSync(manifestContent);
  print('${ConsoleSymbols.checkmark} Created AndroidManifest.xml for $flavor → $domain');
}

void _setupIOSDeeplink(Map<String, String> domains) {
  print('${ConsoleSymbols.apple} Configuring iOS deep-linking...');

  // Ensure Runner directory exists
  final runnerDir = Directory('ios/Runner');
  if (!runnerDir.existsSync()) {
    print('  ${ConsoleSymbols.warning}  ios/Runner directory not found, skipping iOS setup...');
    return;
  }

  for (final flavor in domains.keys) {
    final domain = domains[flavor]!;
    _createIOSEntitlements(flavor, domain);
  }

  print('${ConsoleSymbols.checkmark} iOS deep-linking configured');
}

void _createIOSEntitlements(String flavor, String domain) {
  final entitlementsFile = File('ios/Runner/Runner-$flavor.entitlements');

  if (entitlementsFile.existsSync()) {
    print('${ConsoleSymbols.warning}Runner-$flavor.entitlements already exists, skipping...');
    return;
  }

  // Create directory if it doesn't exist
  entitlementsFile.parent.createSync(recursive: true);

  // Use the template function
  final entitlementsContent = _deeplinkIOSEntitlementsTemplate(domain);

  entitlementsFile.writeAsStringSync(entitlementsContent);
  print('${ConsoleSymbols.checkmark}Created Runner-$flavor.entitlements → applinks:$domain');
}

/// Setup Flutter-side deep link handling
void _setupFlutterDeepLink() {
  try {
    final projectName = getModuleName();
    
    // Step 1: Add app_links dependency
    print('${ConsoleSymbols.package}Adding app_links dependency...');
    _addDependencyToPubspec('app_links', '^6.3.2');
    _runPubGet();
    print('');
    
    // Step 2: Create deep_link_manager.dart
    print('${ConsoleSymbols.file}Creating deep_link_manager.dart...');
    
    final deepLinkDir = Directory('lib/core/utils');
    if (!deepLinkDir.existsSync()) {
      deepLinkDir.createSync(recursive: true);
    }
    
    final deepLinkFile = File('lib/core/utils/deep_link_manager.dart');
    
    if (deepLinkFile.existsSync()) {
      print('${ConsoleSymbols.info}deep_link_manager.dart already exists, skipping...');
    } else {
      final content = deepLinkManagerTemplate(projectName);
      deepLinkFile.writeAsStringSync(content);
      print('${ConsoleSymbols.success}Created lib/core/utils/deep_link_manager.dart');
    }
    
    // Step 3: Modify app.dart to add deep link initialization
    print('${ConsoleSymbols.wrench}Modifying app.dart...');
    modifyAppForDeepLink(projectName);
    
    print('${ConsoleSymbols.success}Flutter deep-link handling configured');
  } catch (e) {
    print('${ConsoleSymbols.error}Error setting up Flutter deep-link: $e');
  }
}
