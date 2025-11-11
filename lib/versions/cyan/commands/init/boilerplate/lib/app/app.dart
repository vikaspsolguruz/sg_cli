import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newarch/app/app_routes/_route_names.dart';
import 'package:newarch/app/app_state.dart';
import 'package:newarch/core/localization/translations.dart';
import 'package:newarch/core/theme/styling/app_theme_data.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:sizer/sizer.dart';


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.themeMode,
    this.locale,
    this.initialRoute,
  });

  final ThemeMode? themeMode;
  final Locale? locale;
  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppState.rootNavigatorKey,
      initialRoute: initialRoute ?? Routes.initialRoute,
      routes: AppState.allRoutesForMaterialApp,
      navigatorObservers: [AppState.navigationObserver],
      theme: AppThemes.light(),
      darkTheme: AppThemes.dark(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: Translations.currentLocales,
      localeResolutionCallback: Translations.resolveLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
  }
}
