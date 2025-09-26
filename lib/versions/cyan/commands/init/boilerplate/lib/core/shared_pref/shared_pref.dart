import 'package:newarch/core/utils/console_print.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pref_manager.dart';

class Prefs {
  Prefs._();

  static late _PrefManager _prefManager;

  static Future<void> initialize() async => _prefManager.initialize();

  static Future<void> clear() async => _prefManager.clear();
}
