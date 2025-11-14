import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newarch/app/app_settings.dart';

part 'locales/english.dart';

class Translations {
  Translations._();

  static Iterable<Locale> get currentLocales => _translationsData.keys.map((e) => Locale(e)).toList();

  static final Map<String, Map<String, String>> _localizedValues = _translationsData;

  static String translate(String key) {
    return _localizedValues[AppSettings.locale.value.languageCode]?[key] ?? _localizedValues['en']?[key] ?? key;
  }

  /// Handles locale resolution for MaterialApp
  static Locale? resolveLocale(Locale? deviceLocale, Iterable<Locale> supportedLocales) {
    final matched = supportedLocales.firstWhere(
      (locale) => locale.languageCode == deviceLocale?.languageCode,
      orElse: () => supportedLocales.first,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => AppSettings.changeLocale(matched));

    return matched;
  }

  static const delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

final Map<String, Map<String, String>> _translationsData = {
  'en': _english,
};
