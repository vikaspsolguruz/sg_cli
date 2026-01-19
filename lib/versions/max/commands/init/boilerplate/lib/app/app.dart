import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:max_arch/app/app_routes/_route_names.dart';
import 'package:max_arch/app/app_settings.dart';
import 'package:max_arch/app/app_state.dart';
import 'package:max_arch/core/localization/translations.dart';
import 'package:max_arch/core/theme/styling/app_theme_data.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialRoute});

  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<({ThemeMode themeMode, Locale locale})>(
      valueListenable: AppSettings.uiSettings,
      builder: (context, uiSettings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppState.rootNavigatorKey,
          initialRoute: initialRoute ?? Routes.initialRoute,
          routes: AppState.allRoutesForMaterialApp,
          navigatorObservers: [AppState.navigationObserver],
          theme: AppThemes.light(),
          darkTheme: AppThemes.dark(),
          themeMode: uiSettings.themeMode,
          locale: uiSettings.locale,
          supportedLocales: Translations.currentLocales,
          localizationsDelegates: Translations.delegates,
          localeResolutionCallback: Translations.resolveLocale,
          builder: (context, child) {
            if (child == null) return const SizedBox();
            AppState.appContext = context;

            return Sizer(
              builder: (context, _, _) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    statusBarBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
                    statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
                  ),
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                    child: child,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
