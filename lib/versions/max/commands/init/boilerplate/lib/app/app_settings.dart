import 'package:flutter/material.dart';
import 'package:max_arch/core/local_storage/local_storage.dart';
import 'package:max_arch/core/localization/translations.dart';
import 'package:max_arch/core/utils/console_print.dart';

class AppSettings {
  static final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.system);
  static final ValueNotifier<Locale> _locale = ValueNotifier(Translations.currentLocales.first);

  static final ValueNotifier<({ThemeMode themeMode, Locale locale})> _uiSettings = ValueNotifier((themeMode: _themeMode.value, locale: _locale.value));

  static ValueNotifier<ThemeMode> get themeMode => _themeMode;

  static ValueNotifier<Locale> get locale => _locale;

  static ValueNotifier<({ThemeMode themeMode, Locale locale})> get uiSettings => _uiSettings;

  /// Initialize settings from LocalStorage (called after LocalStorage.initialize())
  static void init() {
    _themeMode.value = LocalStorage.getThemeMode();

    final localeCode = LocalStorage.getLocale();
    if (localeCode != null) {
      _locale.value = Locale(localeCode);
    }
    _updateSettings();
  }

  static void _updateSettings() {
    _uiSettings.value = (themeMode: _themeMode.value, locale: _locale.value);
  }

  /// Change theme mode
  static void changeTheme(ThemeMode mode) {
    _themeMode.value = mode;
    LocalStorage.setThemeMode(mode);
    _updateSettings();
  }

  /// Change app locale
  static void changeLocale(Locale newLocale) {
    if (newLocale.languageCode == locale.value.languageCode || Translations.currentLocales.every((loc) => loc.languageCode != newLocale.languageCode)) {
      xErrorPrint('Failed to change locale. its either already exist or not supported');
      return;
    }

    _locale.value = newLocale;
    LocalStorage.setLocale(newLocale.languageCode);
    _updateSettings();
  }

  /// Quick access methods
  static void setLightTheme() => changeTheme(ThemeMode.light);

  static void setDarkTheme() => changeTheme(ThemeMode.dark);

  static void setSystemTheme() => changeTheme(ThemeMode.system);
}
