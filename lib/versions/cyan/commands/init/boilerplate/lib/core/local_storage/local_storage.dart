import 'dart:convert';

import 'package:newarch/core/local_storage/pref_keys.dart';
import 'package:newarch/core/models/user_model.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pref_manager.dart';

class LocalStorage {
  LocalStorage._();

  static final _PrefManager _prefManager = _PrefManager();

  static Future<void> initialize() async => await _prefManager.initialize();

  static Future<void> clear() async => _prefManager.clear();

  static Future setDeviceId(String deviceId) async => await _prefManager.setString(PrefKeys.deviceId, deviceId);

  static String? getDeviceId() => _prefManager.getString(PrefKeys.deviceId, dataParser: (value) => value);

  static Future setCurrentUser(UserModel? user) async => await _prefManager.setString(PrefKeys.user, jsonEncode(user?.toJson()));

  static UserModel? getCurrentUser() => _prefManager.getString(PrefKeys.user, dataParser: (value) => UserModel.fromJson(jsonDecode(value)));
}
