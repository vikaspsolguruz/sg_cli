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
}

final Map<String, Map<String, String>> translationsData = {
  'en': _english,
};
