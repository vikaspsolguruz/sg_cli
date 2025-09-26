import 'package:newarch/core/utils/console_print.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pref_manager.dart';

class Prefs {
  Prefs._();

  static final _PrefManager _prefManager = _PrefManager();

  static Future<void> initialize() async => await _prefManager.initialize();

  static Future<void> clear() async => _prefManager.clear();
}
