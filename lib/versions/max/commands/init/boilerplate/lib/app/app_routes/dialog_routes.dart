import 'package:max_arch/app/navigation/app_route.dart';
import 'package:max_arch/app/navigation/route_config.dart';

class DialogRoutes extends RouteConfig {
  static final DialogRoutes _instance = DialogRoutes._();

  static DialogRoutes get instance => _instance;

  DialogRoutes._();

  @override
  List<AppRoute> routes() {
    return [
      // Dialog Routes
    ];
  }
}
