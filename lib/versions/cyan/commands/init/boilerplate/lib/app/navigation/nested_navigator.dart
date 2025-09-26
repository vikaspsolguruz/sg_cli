import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:newarch/app/app_state.dart';
import 'package:newarch/app/navigation/app_route.dart';

class NestedNavigator extends StatelessWidget {
  const NestedNavigator({
    super.key,
    required this.initialInnerRoute,
    required this.parentRoute,
  });

  final String initialInnerRoute;
  final String parentRoute;

  @override
  Widget build(BuildContext context) {
    final route = AppState.routes.where((element) => element.name == parentRoute).firstOrNull;
    final navigatorKey = route?.navigatorKey;

    return Navigator(
      key: navigatorKey,
      initialRoute: initialInnerRoute,
      onGenerateRoute: (RouteSettings settings) {
        final child = getChild(route, settings.name);

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              fillColor: Colors.white,
              child: child,
            );
          },
        );
      },
    );
  }

  Widget? getChild(AppRoute? route, String? subRouteName) {
    return route?.subRoutes.firstWhere((element) => element.name == subRouteName).blocProvider;
  }
}
