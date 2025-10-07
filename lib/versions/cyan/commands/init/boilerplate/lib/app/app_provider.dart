import 'package:flutter/material.dart';
import 'package:newarch/app/app.dart';
import 'package:newarch/app/app_settings.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({super.key, this.initialRoute});

  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettings.themeMode,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: AppSettings.locale,
          builder: (context, locale, _) {
            return MyApp(themeMode: themeMode, locale: locale, initialRoute: initialRoute);
          },
        );
      },
    );
  }
}
