# Patrol Android Setup - Manual Steps Required

The `sg init` command has automatically created the `MainActivityTest.java` file for Android Patrol testing.

However, you need to **manually update** your `android/app/build.gradle` file to complete the setup.

## Required Changes to `android/app/build.gradle`

### 1. Add Test Runner to `defaultConfig` section

```gradle
android {
    defaultConfig {
        // ... existing config ...
        
        // ADD THESE TWO LINES:
        testInstrumentationRunner "pl.leancode.patrol.PatrolJUnitRunner"
        testInstrumentationRunnerArguments clearPackageData: "true"
    }
}
```

### 2. Add Test Options to `android` section

```gradle
android {
    // ... existing config ...
    
    // ADD THIS SECTION:
    testOptions {
        execution "ANDROIDX_TEST_ORCHESTRATOR"
    }
}
```

### 3. Add Test Dependency to `dependencies` section

```gradle
dependencies {
    // ... existing dependencies ...
    
    // ADD THIS LINE:
    androidTestUtil "androidx.test:orchestrator:1.4.2"
}
```

## Complete Example

Here's a complete example of what your `android/app/build.gradle` should look like:

```gradle
android {
    namespace = "com.example.myapp"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.example.myapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName
        
        // Patrol configuration
        testInstrumentationRunner "pl.leancode.patrol.PatrolJUnitRunner"
        testInstrumentationRunnerArguments clearPackageData: "true"
    }

    // Test orchestrator configuration
    testOptions {
        execution "ANDROIDX_TEST_ORCHESTRATOR"
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    
    // Patrol test orchestrator
    androidTestUtil "androidx.test:orchestrator:1.4.2"
}
```

## Running Patrol Tests

Once you've made these changes, you can run Patrol tests with:

```bash
patrol test
```

Or for a specific test:

```bash
patrol test -t integration_test/app_test.dart
```

## Reference

For more information, see the official Patrol documentation:
https://patrol.leancode.co/getting-started
