part of '../max.dart';

void _setupPatrolNative() {
  ConsoleLogger.info('Setting up Patrol native configuration...');
  print('');
  
  _setupPatrolAndroid();
  print('');
  
  _setupPatrolIOS();
  
  print('');
  ConsoleLogger.success('Patrol native configuration completed');
  ConsoleLogger.success('Android: build.gradle has been automatically configured');
  ConsoleLogger.success('iOS: RunnerUITests.m and Podfile updated');
}

void _setupPatrolAndroid() {
  try {
    // Check if Android directory exists
    final androidDir = Directory('android');
    if (!androidDir.existsSync()) {
      print('${ConsoleSymbols.warning}  Android directory not found, skipping Android Patrol setup');
      print('${ConsoleSymbols.info}  Run this command after adding Android support to your project');
      return;
    }

    print('${ConsoleSymbols.loading}  Setting up Android Patrol configuration...');
    
    final packageId = _getBasePackageId();
    print('${ConsoleSymbols.info}  Package ID: $packageId');
    
    final packagePath = packageId.replaceAll('.', '/');
    
    // Create androidTest directory structure
    final testDir = Directory('android/app/src/androidTest/java/$packagePath');
    if (!testDir.existsSync()) {
      print('${ConsoleSymbols.info}  Creating directory: android/app/src/androidTest/java/$packagePath');
      testDir.createSync(recursive: true);
    }
    
    // Create MainActivityTest.java
    final testFile = File('android/app/src/androidTest/java/$packagePath/MainActivityTest.java');
    testFile.writeAsStringSync(_patrolAndroidTestTemplate(packageId));
    
    print('${ConsoleSymbols.success}  Created: android/app/src/androidTest/java/$packagePath/MainActivityTest.java');
    
    // Update build.gradle for Patrol
    _updateAndroidBuildGradleForPatrol();
  } catch (e, stackTrace) {
    print('${ConsoleSymbols.error}  Failed to setup Android Patrol config: $e');
    print('${ConsoleSymbols.info}  You can manually create MainActivityTest.java later');
    if (e.toString().contains('build.gradle')) {
      print('${ConsoleSymbols.info}  Make sure your android/app/build.gradle file exists and has applicationId configured');
    }
  }
}

void _setupPatrolIOS() {
  try {
    // Check if ios directory exists
    final iosDir = Directory('ios');
    if (!iosDir.existsSync()) {
      print('${ConsoleSymbols.warning}  iOS directory not found, skipping iOS Patrol setup');
      print('${ConsoleSymbols.info}  Run this command after adding iOS support to your project');
      return;
    }

    print('${ConsoleSymbols.loading}  Setting up iOS Patrol configuration...');
    
    // Create RunnerUITests directory if it doesn't exist
    final uiTestsDir = Directory('ios/RunnerUITests');
    if (!uiTestsDir.existsSync()) {
      print('${ConsoleSymbols.info}  Creating directory: ios/RunnerUITests');
      uiTestsDir.createSync(recursive: true);
    }
    
    // Create RunnerUITests.m file
    final testFile = File('ios/RunnerUITests/RunnerUITests.m');
    testFile.writeAsStringSync(_patrolIOSTestTemplate());
    
    print('${ConsoleSymbols.success}  Created: ios/RunnerUITests/RunnerUITests.m');
    
    // Update Podfile with robust updater
    _updateIOSPodfileForPatrol();
    
    // Run pod install to update dependencies
    _runPodInstall();
    
    // Print manual steps required
    _printIOSManualSteps();
  } catch (e, stackTrace) {
    print('${ConsoleSymbols.error}  Failed to setup iOS Patrol config: $e');
    print('${ConsoleSymbols.info}  You can manually create RunnerUITests later');
  }
}

void _runPodInstall() {
  try {
    print('${ConsoleSymbols.loading}  Running pod install...');
    final result = Process.runSync('pod', ['install'], workingDirectory: 'ios');
    
    if (result.exitCode == 0) {
      print('${ConsoleSymbols.success}  Pod install completed');
    } else {
      print('${ConsoleSymbols.warning}  Pod install failed (exit code: ${result.exitCode})');
      print('${ConsoleSymbols.info}  Run "cd ios && pod install" manually');
    }
  } catch (e) {
    print('${ConsoleSymbols.warning}  Could not run pod install: $e');
    print('${ConsoleSymbols.info}  Run "cd ios && pod install" manually after setup');
  }
}
