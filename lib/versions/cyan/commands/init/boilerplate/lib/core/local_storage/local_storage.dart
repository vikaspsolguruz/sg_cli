import 'dart:convert';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
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

  static Future setDeviceCountry(CountryCode? country) async => await _prefManager.setString(PrefKeys.deviceCountry, country?.code);

  static CountryCode? getDeviceCountry() => _prefManager.getString(PrefKeys.deviceCountry, dataParser: (value) => CountryCode.fromCode(value));

  static Future setThemeMode(ThemeMode themeMode) async => await _prefManager.setString(PrefKeys.themeMode, themeMode.name);

  static ThemeMode getThemeMode() =>
      (_prefManager.getString(PrefKeys.themeMode, dataParser: (value) => ThemeMode.values.where((tm) => tm.name == value).firstOrNull) ?? ThemeMode.system);

  static Future setLocale(String localeCode) async => await _prefManager.setString(PrefKeys.locale, localeCode);

  static String? getLocale() => _prefManager.getString(PrefKeys.locale, dataParser: (value) => value);

  static void setFcmToken(String token) => _prefManager.setString(PrefKeys.fcmToken, token);

  static String? getFcmToken() => _prefManager.getString(PrefKeys.fcmToken, dataParser: (value) => value);

  static Future<void> setAuthToken(String s, String token) => _prefManager.setString(PrefKeys.authToken, token);

  static String? getAuthToken() => _prefManager.getString(PrefKeys.authToken, dataParser: (value) => value);
}
