import 'package:flutter/material.dart';
import 'package:newarch/app/app_routes/bottom_sheet_routes.dart';
import 'package:newarch/app/app_routes/dialog_routes.dart';
import 'package:newarch/app/app_routes/route_arguments.dart';
import 'package:newarch/app/app_routes/screen_routes.dart';
import 'package:newarch/app/navigation/app_route.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/core/utils/extensions.dart';

class AppState {
  AppState._();

  static List<AppRoute> routes = [];
  static final Map<String, Widget Function(BuildContext)> allRoutesForMaterialApp = {};

  static final navigationObserver = _AppNavigatorObserver();

  static RouteSettings? _currentRouteSettings;

  static void applyNewSettingsFor(BuildContext context) {
    _currentRouteSettings = ModalRoute.of(context)?.settings;
  }

  static RouteArguments get currentRouteArguments => (_currentRouteSettings?.arguments as RouteArguments?) ?? const EmptyArguments();

  static T? currentTypedArguments<T extends RouteArguments>() {
    final args = _currentRouteSettings?.arguments;
    if (args is T) return args;
    return null;
  }

  static String? get currentRouteName => _currentRouteSettings?.name ?? '';

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final mainPageNavigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static late BuildContext appContext;

  static AppColors get colors => appContext.isDarkMode ? AppColors.dark() : AppColors.light();

  /// Must required step before running the app
  static void initializeRoutes() {
    routes = [...ScreenRoutes.instance.routes(), ...BottomSheetRoutes.instance.routes(), ...DialogRoutes.instance.routes()];
    for (final route in routes) {
      allRoutesForMaterialApp[route.name] = (context) => route.blocProvider;
    }
  }
}

class _AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    _print(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {}

  @override
  void didRemove(Route route, Route? previousRoute) {}

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _print(newRoute);
  }
}

void _print(Route? route) {
  final rName = (route?.settings.name ?? '').replaceFirst('/', '');
  xPrint(rName, title: "Navigation");
}
