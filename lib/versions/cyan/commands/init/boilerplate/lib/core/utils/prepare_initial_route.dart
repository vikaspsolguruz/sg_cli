import 'package:newarch/app/app_routes/_route_names.dart';

(String, Map<String, dynamic>?) prepareInitialRoute() {
  String route = Routes.initialRoute;
  Map<String, dynamic>? arguments;

  Routes.initialRoute = route;
  return (route, arguments);
}
