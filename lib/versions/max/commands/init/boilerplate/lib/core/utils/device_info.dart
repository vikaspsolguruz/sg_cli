import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_region/device_region.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:max_arch/core/constants/constants.dart';
import 'package:max_arch/core/local_storage/local_storage.dart';
import 'package:max_arch/core/utils/console_print.dart';

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
  LocalStorage.setDeviceId(deviceId);
  return deviceId;
}

Future<CountryCode> getDeviceCountry() async {
  String? region;
  try {
    region = await DeviceRegion.getSIMCountryCode();
  } catch (e, s) {
    xErrorPrint(e, stackTrace: s);
  }
  return CountryCode.fromCode(region ?? kDefaultRegion)!;
}
