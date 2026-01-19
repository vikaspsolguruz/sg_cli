part of 'local_storage.dart';

late SharedPreferences _sharedPref;

class _PrefManager {
  Future<void> initialize() async => _sharedPref = await SharedPreferences.getInstance();

  Future<void> setString(String key, String? value) async {
    try {
      if (value == null) {
        await _sharedPref.remove(key);
        return;
      }
      await _sharedPref.setString(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> setInt(String key, int? value) async {
    try {
      if (value == null) {
        await _sharedPref.remove(key);
        return;
      }
      await _sharedPref.setInt(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> setBool(String key, bool? value) async {
    try {
      if (value == null) {
        await _sharedPref.remove(key);
        return;
      }
      await _sharedPref.setBool(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> setDouble(String key, double? value) async {
    try {
      if (value == null) {
        await _sharedPref.remove(key);
        return;
      }
      await _sharedPref.setDouble(key, value);
    } catch (e, s) {
      xErrorPrint("Pref Writing failed for $key: $e", stackTrace: s);
    }
  }

  Future<void> setStringList(String key, List<String>? value) async {
    try {
      if (value == null) {
        await _sharedPref.remove(key);
        return;
      }
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

  T? getString<T>(String key, {required T? Function(String value) dataParser}) {
    try {
      final value = _sharedPref.getString(key);
      if (value == null) return null;
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  T? getInt<T>(String key, {required T? Function(int value) dataParser}) {
    try {
      final value = _sharedPref.getInt(key);
      if (value == null) return null;
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  T? getBool<T>(String key, {required T? Function(bool value) dataParser}) {
    try {
      final value = _sharedPref.getBool(key);
      if (value == null) return null;
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  T? getDouble<T>(String key, {required T? Function(double value) dataParser}) {
    try {
      final value = _sharedPref.getDouble(key);
      if (value == null) return null;
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  T? getStringList<T>(String key, {required T? Function(List<String> value) dataParser}) {
    try {
      final value = _sharedPref.getStringList(key);
      if (value == null) return null;
      return dataParser(value);
    } catch (e, s) {
      xErrorPrint("Pref Reading failed for $key: $e", stackTrace: s);
      return null;
    }
  }

  Future<void> clear() async => await _sharedPref.clear();
}
