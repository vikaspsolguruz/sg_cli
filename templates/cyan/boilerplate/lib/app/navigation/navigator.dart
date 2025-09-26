import 'package:flutter/material.dart';
import 'package:newarch/app/app_state.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/presentation/widgets/dialog_wrapper.dart';

class Go {
  Go._();

  static void back<T extends Object?>({T? result, BuildContext? context}) {
    Navigator.of(context ?? AppState.appContext).maybePop(result);
  }

  static backToNamed<T extends Object?>(String routeName, {BuildContext? context}) {
    Navigator.of(context ?? AppState.appContext).popUntil((route) {
      return route.settings.name == routeName || route.isFirst;
    });
  }

  static Future<T?> toNamed<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    final state = _navigatorStateFromScreenRoute(routeName);
    return state?.pushNamed(routeName, arguments: arguments) ?? Future.value();
  }

  static Future<T?> replaceToNamed<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
    Object? result,
  }) {
    final state = _navigatorStateFromScreenRoute(routeName);
    return state?.pushReplacementNamed(routeName, arguments: arguments, result: result) ?? Future.value();
  }

  static Future<T?> popAndToNamed<T extends Object?>(
    String routeName, {
    BuildContext? context,
    Map<String, dynamic>? arguments,
    Object? result,
  }) {
    final state = _navigatorStateFromScreenRoute(routeName);
    return state?.popAndPushNamed(routeName, arguments: arguments, result: result) ?? Future.value();
  }

  static Future<T?> replaceAllToNamed<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    final state = _navigatorStateFromScreenRoute(routeName);
    return state?.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments) ?? Future.value();
  }

  static Future<T?> openBottomSheet<T>(
    String routeName, {
    BuildContext? context,
    Map<String, dynamic>? arguments,
    bool enableDrag = true,
    bool showDragHandle = false,
    bool useSafeArea = true,
    bool isDismissible = true,
  }) {
    context ??= AppState.rootNavigatorKey.currentState?.context;
    if (context == null) return Future.value();

    final bottomSheetView = AppState.routes.where((element) => element.name == routeName).firstOrNull?.blocProvider;
    if (bottomSheetView == null) return Future.value();
    return showModalBottomSheet(
      context: context,
      useSafeArea: useSafeArea,
      showDragHandle: showDragHandle,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      routeSettings: RouteSettings(name: routeName, arguments: arguments),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      builder: (BuildContext context) => bottomSheetView,
    );
  }

  static Future<T?> openDialog<T extends Object?>(
    String routeName, {
    BuildContext? context,
    bool isDismissible = true,
    Map<String, dynamic>? arguments,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final state = _navigatorStateFromScreenRoute(routeName);
    final dialogView = AppState.routes.where((element) => element.name == routeName).firstOrNull?.blocProvider;
    if (dialogView == null || state == null) return Future.value();

    return state.push(
      RawDialogRoute(
        pageBuilder: (context, animation, secondaryAnimation) => DialogWrapper(alignment: alignment, child: dialogView),
        settings: RouteSettings(name: routeName, arguments: arguments),
        barrierDismissible: isDismissible,
      ),
    );
  }

  static Future<T?> to<T extends Object?>(
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
