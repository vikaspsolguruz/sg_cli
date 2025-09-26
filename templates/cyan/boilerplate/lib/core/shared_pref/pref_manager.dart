part of 'shared_pref.dart';

late SharedPreferences _sharedPref;

class _PrefManager {
  Future<void> initialize() async => _sharedPref = await SharedPreferences.getInstance();

  Future<void> setString(String key, String value) async {
    try {
      await _sharedPref.setString(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> setInt(String key, int value) async {
    try {
      await _sharedPref.setInt(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> setBool(String key, bool value) async {
    try {
      await _sharedPref.setBool(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> setDouble(String key, double value) async {
    try {
      await _sharedPref.setDouble(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> setStringList(String key, List<String> value) async {
    try {
      await _sharedPref.setStringList(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> remove(String key) async {
    try {
      await _sharedPref.remove(key);
    } catch (e, s) {
      xErrorPrint("Pref Removal failed for $key: $e", stackTrace: s);
    }
  }

  static Future<T?> getString<T>(String key, {required T Function(String?) dataParser}) async {
    try {
      final value = _sharedPref.getString(key);
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  static Future<T?> getInt<T>(String key, {required T Function(int?) dataParser}) async {
    try {
      final value = _sharedPref.getInt(key);
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  static Future<T?> getBool<T>(String key, {required T Function(bool?) dataParser}) async {
    try {
      final value = _sharedPref.getBool(key);
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  static Future<T?> getDouble<T>(String key, {required T Function(double?) dataParser}) async {
    try {
      final value = _sharedPref.getDouble(key);
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  static Future<T?> getStringList<T>(String key, {required T Function(List<String>?) dataParser}) async {
    try {
      final value = _sharedPref.getStringList(key);
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  Future<void> clear() async => await _sharedPref.clear();
}
