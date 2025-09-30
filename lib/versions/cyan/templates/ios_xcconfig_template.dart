part of '../cyan.dart';

String _iosXcconfigTemplate(String flavor, String packageName) {
  final bundleId = flavor == 'prod' ? packageName : '$packageName.$flavor';
  final displayName = flavor == 'prod' ? 'App' : '${flavor.toUpperCase()} App';
  
  return '''// Configuration settings file format documentation can be found at:
// https://help.apple.com/xcode/#/dev745c5c974

PRODUCT_BUNDLE_IDENTIFIER = $bundleId
APP_DISPLAY_NAME = $displayName
''';
}
