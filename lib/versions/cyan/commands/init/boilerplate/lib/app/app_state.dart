import 'package:flutter/material.dart';
import 'package:newarch/app/app_routes/bottom_sheet_routes.dart';
import 'package:newarch/app/app_routes/dialog_routes.dart';
import 'package:newarch/app/app_routes/screen_routes.dart';
import 'package:newarch/app/navigation/app_route.dart';
import 'package:newarch/core/utils/console_print.dart';

class AppState {
  AppState._();

  static List<AppRoute> routes = [];

  static final navigationObserver = _AppNavigatorObserver();

  static RouteSettings? _currentRouteSettings;

  static applyNewSettingsFor(BuildContext context) {
    _currentRouteSettings = ModalRoute.of(context)?.settings;
  }

  static Map<String, dynamic> get currentRouteArguments => (_currentRouteSettings?.arguments as Map<String, dynamic>?) ?? {};

  static String? get currentRouteName => _currentRouteSettings?.name ?? '';

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final mainPageNavigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static BuildContext get appContext => rootNavigatorKey.currentContext!;

  /// Must required step before running the app
  static void initializeRoutes() {
    routes = [...ScreenRoutes().routes(), ...BottomSheetRoutes().routes(), ...DialogRoutes().routes()];
  }
}

class _AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('push');
    print([previousRoute?.settings.name, route.settings.name]);
    _print(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('pop');
    print([previousRoute?.settings.name, route.settings.name]);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    print('remove');
    print([previousRoute?.settings.name, route.settings.name]);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('replace');
    print([oldRoute?.settings.name, newRoute?.settings.name]);
    _print(newRoute);
  }
}

void _print(Route? route) {
  final rName = (route?.settings.name ?? '').replaceFirst('/', '');
  xPrint(rName, title: "Navigation");
}
