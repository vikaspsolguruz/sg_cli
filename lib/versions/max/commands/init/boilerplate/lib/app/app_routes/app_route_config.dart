import 'package:max_arch/app/app_routes/_route_names.dart';
import 'package:max_arch/app/app_routes/route_arguments.dart';

abstract class AppRouteConfig<T extends RouteArguments> {
  final T? arguments;

  const AppRouteConfig({this.arguments});

  String get routeName;
}

class SelectCountryRoute extends AppRouteConfig<SelectCountryArguments> {
  const SelectCountryRoute({super.arguments});

  @override
  String get routeName => Routes.selectCountry;
}
