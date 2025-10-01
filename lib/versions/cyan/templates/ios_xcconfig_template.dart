part of '../cyan.dart';

String _iosXcconfigTemplate(String flavor, String packageName, String appLabel) {
  final bundleId = flavor == 'prod' ? packageName : '$packageName.$flavor';
  
  // Capitalize flavor name: dev -> Dev, stage -> Stage
  final flavorPrefix = flavor == 'prod' 
      ? '' 
      : '${flavor[0].toUpperCase()}${flavor.substring(1)} ';
  
  final displayName = '$flavorPrefix$appLabel';
  
  return '''// Configuration settings file format documentation can be found at:
// https://help.apple.com/xcode/#/dev745c5c974

PRODUCT_BUNDLE_IDENTIFIER = $bundleId
APP_DISPLAY_NAME = $displayName
''';
}
