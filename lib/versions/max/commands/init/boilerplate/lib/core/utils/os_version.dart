import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:max_arch/core/utils/console_print.dart';

Future<String> getOSVersion() async {
  final deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return 'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return 'iOS ${iosInfo.systemVersion}';
    }
  } catch (e, s) {
    xErrorPrint(e, stackTrace: s);
  }
  return 'Unsupported Platform';
}
