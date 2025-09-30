part of '../cyan.dart';

String _deeplinkIOSEntitlementsTemplate(String domain) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
\t<key>com.apple.developer.associated-domains</key>
\t<array>
\t\t<string>applinks:$domain</string>
\t</array>
</dict>
</plist>
''';
}
