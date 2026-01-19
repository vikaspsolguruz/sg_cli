import 'package:flutter/material.dart';
import 'package:max_arch/app/app_routes/app_route_config.dart';
import 'package:max_arch/app/app_routes/route_arguments.dart';
import 'package:max_arch/app/app_state.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:max_arch/presentation/widgets/dialog_wrapper.dart';

class Go {
  Go._();

  static void back<T extends Object?>({T? result, BuildContext? context}) {
    Navigator.of(context ?? AppState.appContext).maybePop(result);
  }

  static void backToNamed<T extends Object?>(String routeName, {BuildContext? context}) {
    Navigator.of(context ?? AppState.appContext).popUntil((route) {
      return route.settings.name == routeName || route.isFirst;
    });
  }

  static Future<T?> to<T extends Object?, A extends RouteArguments>(
    AppRouteConfig<A> route,
  ) {
    final state = _navigatorStateFromScreenRoute(route.routeName);
    return state?.pushNamed(route.routeName, arguments: route.arguments) ?? Future.value();
  }

  static Future<T?> replaceTo<T extends Object?, A extends RouteArguments>(
    AppRouteConfig<A> route, {
    Object? result,
  }) {
    final state = _navigatorStateFromScreenRoute(route.routeName);
    return state?.pushReplacementNamed(route.routeName, arguments: route.arguments, result: result) ?? Future.value();
  }

  static Future<T?> popAndTo<T extends Object?, A extends RouteArguments>(
    AppRouteConfig<A> route, {
    BuildContext? context,
    Object? result,
  }) {
    final state = _navigatorStateFromScreenRoute(route.routeName);
    return state?.popAndPushNamed(route.routeName, arguments: route.arguments, result: result) ?? Future.value();
  }

  static Future<T?> replaceAllTo<T extends Object?, A extends RouteArguments>(
    AppRouteConfig<A> route,
  ) {
    final state = _navigatorStateFromScreenRoute(route.routeName);
    return state?.pushNamedAndRemoveUntil(route.routeName, (route) => false, arguments: route.arguments) ?? Future.value();
  }

  static Future<T?> openBottomSheet<T, A extends RouteArguments>(
    AppRouteConfig<A> route, {
    BuildContext? context,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool useSafeArea = true,
    bool isDismissible = true,
  }) {
    context ??= AppState.rootNavigatorKey.currentState?.context;
    if (context == null) return Future.value();

    final bottomSheetView = AppState.routes.where((element) => element.name == route.routeName).firstOrNull?.blocProvider;
    if (bottomSheetView == null) return Future.value();
    return showModalBottomSheet(
      context: context,
      useSafeArea: useSafeArea,
      showDragHandle: showDragHandle,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      routeSettings: RouteSettings(name: route.routeName, arguments: route.arguments),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      builder: (BuildContext context) => bottomSheetView,
    );
  }

  static Future<T?> openDialog<T extends Object?, A extends RouteArguments>(
    AppRouteConfig<A> route, {
    BuildContext? context,
    bool isDismissible = true,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final state = _navigatorStateFromScreenRoute(route.routeName);
    final dialogView = AppState.routes.where((element) => element.name == route.routeName).firstOrNull?.blocProvider;
    if (dialogView == null || state == null) return Future.value();

    return state.push(
      RawDialogRoute(
        pageBuilder: (context, animation, secondaryAnimation) => DialogWrapper(alignment: alignment, child: dialogView),
        settings: RouteSettings(name: route.routeName, arguments: route.arguments),
        barrierDismissible: isDismissible,
      ),
    );
  }

  static Future<T?> toWidget<T extends Object?>(
    Widget page, {
    BuildContext? context,
    Map<String, dynamic>? arguments,
  }) {
    return Navigator.of(context.secured).push(
      MaterialPageRoute(
        builder: (BuildContext context) => page,
        settings: RouteSettings(
          name: "/${page.runtimeType}",
          arguments: arguments,
        ),
      ),
    );
  }

  static NavigatorState? _navigatorStateFromScreenRoute(String routeName) {
    final navigatorKey = AppState.routes.where((parent) => parent.subRoutes.any((sub) => sub.name == routeName)).firstOrNull?.navigatorKey;
    return navigatorKey?.currentState ?? AppState.rootNavigatorKey.currentState;
  }
}
