import 'package:newarch/app/app_routes/_route_names.dart';
import 'package:newarch/app/navigation/app_route.dart';
import 'package:newarch/app/navigation/route_config.dart';
import 'package:newarch/core/utils/bloc/bloc_route_provider.dart';
import 'package:newarch/presentation/bottom_sheets/select_country/logic/select_country_bloc.dart';
import 'package:newarch/presentation/bottom_sheets/select_country/view/select_country_bs.dart';

class BottomSheetRoutes extends RouteConfig {
  @override
  List<AppRoute> routes() {
    return [
      // Bottom Sheet Routes
      AppRoute(
        name: Routes.selectCountry,
        blocProvider: BlocRouteProvider<SelectCountryBloc>(
          bloc: (context) => SelectCountryBloc(),
          page: const SelectCountryBottomSheet(),
        ),
      ),
    ];
  }
}
