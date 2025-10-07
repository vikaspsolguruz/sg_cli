import 'package:flutter/material.dart';
import 'package:newarch/core/local_storage/local_storage.dart';
import 'package:newarch/core/localization/translations.dart';

class AppSettings {
  static final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.system);
  static final ValueNotifier<Locale> _locale = ValueNotifier(Translations.currentLocales.first);

  static ValueNotifier<ThemeMode> get themeMode => _themeMode;

  static ValueNotifier<Locale> get locale => _locale;

  /// Initialize settings from LocalStorage (called after LocalStorage.initialize())
  static void init() {
    _themeMode.value = LocalStorage.getThemeMode();

    final localeCode = LocalStorage.getLocale();
    if (localeCode != null) {
      _locale.value = Locale(localeCode);
    }
  }

  /// Change theme mode
  static void changeTheme(ThemeMode mode) {
    _themeMode.value = mode;
    LocalStorage.setThemeMode(mode);
  }

  /// Change app locale
  static void changeLocale(Locale newLocale) {
    if (newLocale == locale.value) return;
    _locale.value = newLocale;
    LocalStorage.setLocale(newLocale.languageCode);
  }

  /// Quick access methods
  static void setLightTheme() => changeTheme(ThemeMode.light);

  static void setDarkTheme() => changeTheme(ThemeMode.dark);

  static void setSystemTheme() => changeTheme(ThemeMode.system);
}
