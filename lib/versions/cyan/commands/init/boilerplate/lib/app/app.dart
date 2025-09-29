import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newarch/app/app_routes/_route_names.dart';
import 'package:newarch/app/app_state.dart';
import 'package:newarch/core/theme/styling/app_theme_data.dart';
import 'package:newarch/core/utils/localization/translations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Widget Function(BuildContext)> routes = {};

  @override
  void initState() {
    for (final route in AppState.routes) {
      routes[route.name] = (context) => route.blocProvider;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppState.rootNavigatorKey,
      initialRoute: Routes.initialRoute,
      routes: routes,
      navigatorObservers: [AppState.navigationObserver],
      theme: AppThemes.light(),
      darkTheme: AppThemes.dark(),
      supportedLocales: const [
        Locale('en'),
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        final matched = supportedLocales.firstWhere(
          (locale) => locale.languageCode == deviceLocale?.languageCode,
          orElse: () => supportedLocales.first,
        );
        Translations.instance.changeLocale(matched);
        return matched;
      },
      builder: (context, child) {
        if (child == null) return const SizedBox();
        AppState.appContext = context;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            child: child,
          ),
        );
      },
    );
  }
}
