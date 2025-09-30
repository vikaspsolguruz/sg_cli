part of '../../cyan.dart';

void _setupDeeplink() {
  print('');
  print('🔗 Setting up deep-linking for flavors...');
  print('');

  // Validate cyan config exists
  if (!_validateCyanConfig()) {
    return;
  }

  try {
    // Check if flavors exist
    if (!_checkFlavorsExist()) {
      print(' ❌ Error: Product flavors not found!');
      print('   Please run: sg setup_flavors first');
      return;
    }

    print('📝 Please provide deep-link domains for each flavor:');
    print('');

    // Get domains for each flavor
    stdout.write('🔸 Dev domain (e.g., myapp-dev.example.com): ');
    final devDomain = stdin.readLineSync()?.trim() ?? '';

    stdout.write('🔸 Stage domain (e.g., myapp-stage.example.com): ');
    final stageDomain = stdin.readLineSync()?.trim() ?? '';

    stdout.write('🔸 Prod domain (e.g., myapp.example.com): ');
    final prodDomain = stdin.readLineSync()?.trim() ?? '';

    if (devDomain.isEmpty || stageDomain.isEmpty || prodDomain.isEmpty) {
      print(' ❌ All domains are required!');
      return;
    }

    print('');
    print(' 🚀 Configuring deep-linking...');
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

    print('');
    print('╔════════════════════════════════════════════════════════════════════════════════╗');
    print('║                   ✅ Deep-Linking Setup Complete!                             ║');
    print('╚════════════════════════════════════════════════════════════════════════════════╝');
    print('');
    print('📱 Android Configuration:');
    print('   ✓ Created AndroidManifest.xml for each flavor');
    print('     • android/app/src/dev/AndroidManifest.xml → $devDomain');
    print('     • android/app/src/stage/AndroidManifest.xml → $stageDomain');
    print('     • android/app/src/prod/AndroidManifest.xml → $prodDomain');
    print('');
    print('🍎 iOS Configuration:');
    print('   ✓ Created entitlements for each flavor');
    print('     • ios/Runner/Runner-dev.entitlements → applinks:$devDomain');
    print('     • ios/Runner/Runner-stage.entitlements → applinks:$stageDomain');
    print('     • ios/Runner/Runner-prod.entitlements → applinks:$prodDomain');
    print('');
    print('⚠️  iOS Xcode Configuration Required:');
    print('   1. Open ios/Runner.xcworkspace in Xcode');
    print('   2. Select Runner target → Build Settings');
    print('   3. Search for "Code Signing Entitlements"');
    print('   4. Set entitlements per configuration:');
    print('      • Debug-dev: Runner/Runner-dev.entitlements');
    print('      • Debug-stage: Runner/Runner-stage.entitlements');
    print('      • Release: Runner/Runner-prod.entitlements');
    print('');
    print('🌐 Domain Verification:');
    print('   Don\'t forget to upload apple-app-site-association file to:');
    print('   • https://$devDomain/.well-known/apple-app-site-association');
    print('   • https://$stageDomain/.well-known/apple-app-site-association');
    print('   • https://$prodDomain/.well-known/apple-app-site-association');
    print('');
  } catch (e) {
    print(' ❌ Error during deep-link setup: $e');
  }
}

bool _checkFlavorsExist() {
  final devDir = Directory('android/app/src/dev');
  final stageDir = Directory('android/app/src/stage');
  final prodDir = Directory('android/app/src/prod');

  return devDir.existsSync() && stageDir.existsSync() && prodDir.existsSync();
}

void _setupAndroidDeeplink(Map<String, String> domains) {
  print('🤖 Configuring Android deep-linking...');

  for (final flavor in domains.keys) {
    final domain = domains[flavor]!;
    _createAndroidManifest(flavor, domain);
  }

  print('✓ Android deep-linking configured');
}

void _createAndroidManifest(String flavor, String domain) {
  final manifestFile = File('android/app/src/$flavor/AndroidManifest.xml');

  if (manifestFile.existsSync()) {
    print('  ⚠️  AndroidManifest.xml already exists for $flavor, skipping...');
    return;
  }

  String manifestContent = File('templates/android_manifest.xml').readAsStringSync();
  manifestContent = manifestContent.replaceFirst('{{domain}}', domain);

  manifestFile.writeAsStringSync(manifestContent);
  print('  ✓ Created AndroidManifest.xml for $flavor → $domain');
}

void _setupIOSDeeplink(Map<String, String> domains) {
  print('🍎 Configuring iOS deep-linking...');

  // Ensure Runner directory exists
  final runnerDir = Directory('ios/Runner');
  if (!runnerDir.existsSync()) {
    print('  ⚠️  ios/Runner directory not found, skipping iOS setup...');
    return;
  }

  for (final flavor in domains.keys) {
    final domain = domains[flavor]!;
    _createIOSEntitlements(flavor, domain);
  }

  print('✓ iOS deep-linking configured');
}

void _createIOSEntitlements(String flavor, String domain) {
  final entitlementsFile = File('ios/Runner/Runner-$flavor.entitlements');

  if (entitlementsFile.existsSync()) {
    print('  ⚠️  Runner-$flavor.entitlements already exists, skipping...');
    return;
  }

  String entitlementsContent = File('templates/ios_entitlements.plist').readAsStringSync();
  entitlementsContent = entitlementsContent.replaceFirst('{{domain}}', domain);

  entitlementsFile.writeAsStringSync(entitlementsContent);
  print('  ✓ Created Runner-$flavor.entitlements → applinks:$domain');
}
