import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:newarch/core/shared_pref/shared_pref.dart';
import 'package:newarch/core/utils/console_print.dart';

Future<String> getDeviceId() async {
  String deviceId = '';
  try {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
    }
  } catch (e, s) {
    xErrorPrint(e, stackTrace: s);
  }
  Prefs.setDeviceId(deviceId);
  return deviceId;
}
