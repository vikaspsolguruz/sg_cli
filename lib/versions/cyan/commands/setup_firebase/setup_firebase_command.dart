part of '../../cyan.dart';

void _setupFirebase() {
  print('');
  print('🔥 Setting up Firebase configurations for flavors...');
  print('');
  
  // Validate cyan config exists
  if (!_validateCyanConfig()) {
    return;
  }
  
  try {
    // Check if flavors exist
    if (!_checkFlavorsExist()) {
      print('❌ Error: Product flavors not found!');
      print('   Please run: sg setup_flavors first');
      return;
    }
    
    // Get package name
    final packageName = _getBasePackageId();
    print('🆔 Package ID: $packageName');
    print('');
    
    print('🚀 Generating placeholder Firebase configs...');
    print('');
    
    // Setup Android Firebase configs
    _setupAndroidFirebase(packageName);
    
    // Setup iOS Firebase configs
    _setupIOSFirebase(packageName);
    
    print('');
    print('╔════════════════════════════════════════════════════════════════════════════════╗');
    print('║                   ✅ Firebase Setup Complete!                                  ║');
    print('╚════════════════════════════════════════════════════════════════════════════════╝');
    print('');
    print('📱 Android Configuration:');
    print('   ✓ Placeholder google-services.json created for each flavor');
    print('     • android/app/src/dev/google-services.json');
    print('     • android/app/src/stage/google-services.json');
    print('     • android/app/src/prod/google-services.json');
    print('');
    print('🍎 iOS Configuration:');
    print('   ✓ Placeholder GoogleService-Info.plist created for each flavor');
    print('     • ios/config/dev/GoogleService-Info.plist');
    print('     • ios/config/stage/GoogleService-Info.plist');
    print('     • ios/config/prod/GoogleService-Info.plist');
    print('');
    print('🔥 Firebase Console Setup Required:');
    print('   1. Go to https://console.firebase.google.com');
    print('   2. Create or select your project');
    print('   3. Add Android apps for each flavor:');
    print('      • Dev:   $packageName.dev');
    print('      • Stage: $packageName.stage');
    print('      • Prod:  $packageName');
    print('   4. Download google-services.json for each');
    print('   5. Replace placeholder files in android/app/src/{flavor}/');
    print('');
    print('   6. Add iOS apps for each flavor');
    print('   7. Download GoogleService-Info.plist for each');
    print('   8. Replace placeholder files in ios/config/{flavor}/');
    print('');
    print('💡 iOS Xcode Configuration:');
    print('   After replacing real Firebase configs, configure build phases in Xcode');
    print('   to copy the correct config file per flavor using a Run Script:');
    print('');
    print('   # Add this to Build Phases → New Run Script Phase');
    print('   if [ "\${CONFIGURATION}" == "Debug-dev" ] || [ "\${CONFIGURATION}" == "Release-dev" ]; then');
    print('       cp -r "\${PROJECT_DIR}/Runner/config/dev/GoogleService-Info.plist" "\${BUILT_PRODUCTS_DIR}/\${PRODUCT_NAME}.app/GoogleService-Info.plist"');
    print('   elif [ "\${CONFIGURATION}" == "Debug-stage" ] || [ "\${CONFIGURATION}" == "Release-stage" ]; then');
    print('       cp -r "\${PROJECT_DIR}/Runner/config/stage/GoogleService-Info.plist" "\${BUILT_PRODUCTS_DIR}/\${PRODUCT_NAME}.app/GoogleService-Info.plist"');
    print('   else');
    print('       cp -r "\${PROJECT_DIR}/Runner/config/prod/GoogleService-Info.plist" "\${BUILT_PRODUCTS_DIR}/\${PRODUCT_NAME}.app/GoogleService-Info.plist"');
    print('   fi');
    print('');
    
  } catch (e) {
    print('❌ Error during Firebase setup: $e');
  }
}

void _setupAndroidFirebase(String packageName) {
  print('🤖 Configuring Android Firebase...');
  
  final flavors = ['dev', 'stage', 'prod'];
  
  for (final flavor in flavors) {
    _createAndroidFirebaseConfig(flavor, packageName);
  }
  
  print('✓ Android Firebase configs generated');
}

void _createAndroidFirebaseConfig(String flavor, String packageName) {
  final firebaseFile = File('android/app/src/$flavor/google-services.json');
  
  if (firebaseFile.existsSync()) {
    print('  ⚠️  google-services.json already exists for $flavor, skipping...');
    return;
  }
  
  final placeholderContent = _placeholderFirebaseAndroidConfigTemplate(flavor, packageName);
  
  firebaseFile.writeAsStringSync(placeholderContent);
  print('  ✓ Created google-services.json for $flavor');
}

void _setupIOSFirebase(String packageName) {
  print('🍎 Configuring iOS Firebase...');
  
  final flavors = ['dev', 'stage', 'prod'];
  
  // Create config directory structure
  for (final flavor in flavors) {
    final configDir = Directory('ios/config/$flavor');
    if (!configDir.existsSync()) {
      configDir.createSync(recursive: true);
    }
    
    _createIOSFirebaseConfig(flavor, packageName);
  }
  
  print('✓ iOS Firebase configs generated');
}

void _createIOSFirebaseConfig(String flavor, String packageName) {
  final firebaseFile = File('ios/config/$flavor/GoogleService-Info.plist');
  
  if (firebaseFile.existsSync()) {
    print('  ⚠️  GoogleService-Info.plist already exists for $flavor, skipping...');
    return;
  }
  
  final placeholderContent = _placeholderFirebaseIOSConfigTemplate(flavor, packageName);
  
  firebaseFile.writeAsStringSync(placeholderContent);
  print('  ✓ Created GoogleService-Info.plist for $flavor');
}
