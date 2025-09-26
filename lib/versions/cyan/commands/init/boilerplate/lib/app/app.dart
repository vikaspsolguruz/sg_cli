import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newarch/app/app_routes/_route_names.dart';
import 'package:newarch/app/app_state.dart';

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
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.orangeAccent),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      builder: (context, child) {
        if (child == null) return const SizedBox();

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
