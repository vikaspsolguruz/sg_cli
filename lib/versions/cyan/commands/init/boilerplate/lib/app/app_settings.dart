import 'package:flutter/material.dart';
import 'package:newarch/core/local_storage/local_storage.dart';

class AppSettings {
  static final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.system);
  static final ValueNotifier<Locale> _locale = ValueNotifier(const Locale('en'));

  static ValueNotifier<ThemeMode> get themeMode => _themeMode;

  static ValueNotifier<Locale> get locale => _locale;

  /// Initialize settings from LocalStorage (called after LocalStorage.initialize())
  static void init() {
    // Load theme mode
    final themeModeString = LocalStorage.getThemeMode();
    if (themeModeString != null) {
      _themeMode.value = _parseThemeMode(themeModeString);
    }

    // Load locale
    final localeCode = LocalStorage.getLocale();
    if (localeCode != null) {
      _locale.value = Locale(localeCode);
    }
  }

  /// Change theme mode
  static void changeTheme(ThemeMode mode) {
    _themeMode.value = mode;
    LocalStorage.setThemeMode(_themeModeToString(mode));
  }

  /// Convert ThemeMode to string for storage
  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Parse stored string back to ThemeMode
  static ThemeMode _parseThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system; // Fallback to system
    }
  }

  /// Change app locale
  static void changeLocale(Locale newLocale) {
    _locale.value = newLocale;
    LocalStorage.setLocale(newLocale.languageCode);
  }

  /// Quick access methods
  static void setLightTheme() => changeTheme(ThemeMode.light);

  static void setDarkTheme() => changeTheme(ThemeMode.dark);

  static void setSystemTheme() => changeTheme(ThemeMode.system);
}
