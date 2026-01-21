import 'package:device_region/device_region.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:max_arch/core/constants/constants.dart';
import 'package:max_arch/core/local_storage/local_storage.dart';
import 'package:max_arch/core/utils/console_print.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:uuid/v1.dart';

String getDeviceId() {
  String deviceId;
  try {
    deviceId = LocalStorage.getDeviceId().nullable ?? const UuidV1().generate();
    if (deviceId.isNotEmpty) return deviceId;
  } catch (e, s) {
    xErrorPrint(e, stackTrace: s);
    deviceId = DateTime.now().microsecondsSinceEpoch.toString();
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
