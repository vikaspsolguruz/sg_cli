import 'dart:ui';

part 'locales/english.dart';

class Translations {
  static final Translations instance = Translations._();

  Translations._();

  final Map<String, Map<String, String>> _localizedValues = translationsData;
  Locale _currentLocale = const Locale('en');

  void changeLocale(Locale locale) {
    _currentLocale = locale;
  }

  String translate(String key) {
    return _localizedValues[_currentLocale.languageCode]?[key] ?? _localizedValues['en']?[key] ?? key;
  }

  Locale get currentLocale => _currentLocale;

  /// Handles locale resolution for MaterialApp
  static Locale? resolveLocale(Locale? deviceLocale, Iterable<Locale> supportedLocales) {
    // Find best match between device and supported locales
    final matched = supportedLocales.firstWhere(
      (locale) => locale.languageCode == deviceLocale?.languageCode,
      orElse: () => supportedLocales.first,
    );

    // Update the translation system with the matched locale
    instance.changeLocale(matched);

    // Return the matched locale for Flutter to use
    return matched;
  }
}

final Map<String, Map<String, String>> translationsData = {
  'en': _english,
};
