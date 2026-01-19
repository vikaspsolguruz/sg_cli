import 'package:max_arch/app/navigation/app_route.dart';
import 'package:max_arch/app/navigation/route_config.dart';

class ScreenRoutes extends RouteConfig {
  static final ScreenRoutes _instance = ScreenRoutes._();

  static ScreenRoutes get instance => _instance;

  ScreenRoutes._();

  @override
  List<AppRoute> routes() {
    return [
      // Screen Routes
    ];
  }
}
