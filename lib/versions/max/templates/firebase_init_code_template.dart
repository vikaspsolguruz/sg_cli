part of '../max.dart';

/// Template for flavored Firebase initialization (using Environments enum)
String _firebaseInitCodeFlavoredTemplate(String projectName) {
  return '''
  // Firebase initialization for flavored project
    final firebaseOptions = switch (currentEnvironment) {
      Environments.local => dev.DefaultFirebaseOptions.currentPlatform,
      Environments.dev => dev.DefaultFirebaseOptions.currentPlatform,
      Environments.stage => stage.DefaultFirebaseOptions.currentPlatform,
      Environments.prod => prod.DefaultFirebaseOptions.currentPlatform,
      _ => dev.DefaultFirebaseOptions.currentPlatform,
  };
  
    await Firebase.initializeApp(options: firebaseOptions);''';
}

/// Template for non-flavored Firebase initialization
String _firebaseInitCodeSingleTemplate() {
  return '''
  // Firebase initialization
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);''';
}
