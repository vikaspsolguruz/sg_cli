import 'package:max_arch/app/app_routes/app_route_config.dart';
import 'package:max_arch/app/navigation/app_route.dart';
import 'package:max_arch/app/navigation/route_config.dart';
import 'package:max_arch/core/utils/bloc/bloc_route_provider.dart';
import 'package:max_arch/presentation/bottom_sheets/select_country/logic/select_country_bloc.dart';
import 'package:max_arch/presentation/bottom_sheets/select_country/view/select_country_bs.dart';

class BottomSheetRoutes extends RouteConfig {
  static final BottomSheetRoutes _instance = BottomSheetRoutes._();

  static BottomSheetRoutes get instance => _instance;

  BottomSheetRoutes._();

  @override
  List<AppRoute> routes() {
    return [
      // Bottom Sheet Routes
      AppRoute(
        config: const SelectCountryRoute(),
        blocProvider: BlocRouteProvider<SelectCountryBloc>(
          bloc: (context) => SelectCountryBloc(),
          page: const SelectCountryBottomSheet(),
        ),
      ),
    ];
  }
}
