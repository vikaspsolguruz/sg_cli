part of '../max.dart';

String _placeholderFirebaseIOSConfigTemplate(String flavor, String packageName) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
\t<key>API_KEY</key>
\t<string>YOUR_IOS_API_KEY_HERE</string>
\t<key>GCM_SENDER_ID</key>
\t<string>YOUR_GCM_SENDER_ID</string>
\t<key>PLIST_VERSION</key>
\t<string>1</string>
\t<key>BUNDLE_ID</key>
\t<string>$packageName${flavor == 'prod' ? '' : '.$flavor'}</string>
\t<key>PROJECT_ID</key>
\t<string>your-project-id-$flavor</string>
\t<key>STORAGE_BUCKET</key>
\t<string>your-project-id-$flavor.appspot.com</string>
\t<key>IS_ADS_ENABLED</key>
\t<false/>
\t<key>IS_ANALYTICS_ENABLED</key>
\t<false/>
\t<key>IS_APPINVITE_ENABLED</key>
\t<true/>
\t<key>IS_GCM_ENABLED</key>
\t<true/>
\t<key>IS_SIGNIN_ENABLED</key>
\t<true/>
\t<key>GOOGLE_APP_ID</key>
\t<string>1:YOUR_PROJECT_NUMBER:ios:YOUR_APP_ID</string>
\t<key>DATABASE_URL</key>
\t<string>https://your-project-id-$flavor.firebaseio.com</string>
</dict>
</plist>
''';
}
