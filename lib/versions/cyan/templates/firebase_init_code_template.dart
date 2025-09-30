part of '../cyan.dart';

/// Template for flavored Firebase initialization (nurses_now pattern)
String _firebaseInitCodeFlavoredTemplate(String projectName) {
  return '''
  // Firebase initialization for flavored project
  final firebaseOptions = switch (appFlavor) {
    AppFlavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
    AppFlavor.stage => stage.DefaultFirebaseOptions.currentPlatform,
    AppFlavor.prod => prod.DefaultFirebaseOptions.currentPlatform,
  };
  
  await Firebase.initializeApp(options: firebaseOptions);''';
}

/// Template for non-flavored Firebase initialization
String _firebaseInitCodeSingleTemplate() {
  return '''
  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );''';
}
