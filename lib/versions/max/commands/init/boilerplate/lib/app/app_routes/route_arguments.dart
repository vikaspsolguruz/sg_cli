import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:max_arch/app/app_routes/route_arguments_provider.dart';

abstract class RouteArguments {
  const RouteArguments();
}

class EmptyArguments extends RouteArguments {
  const EmptyArguments();

  static EmptyArguments? get() => RouteArgumentsProvider.get<EmptyArguments>();
}

class HomeArguments extends RouteArguments {
  final String? email;

  const HomeArguments({this.email});

  static HomeArguments? get() => RouteArgumentsProvider.get<HomeArguments>();
}

class SettingsArguments extends RouteArguments {
  final String userId;

  const SettingsArguments({required this.userId});

  static SettingsArguments? get() => RouteArgumentsProvider.get<SettingsArguments>();
}

class SelectCountryArguments extends RouteArguments {
  final CountryCode? selectedCountry;

  const SelectCountryArguments({this.selectedCountry});

  static SelectCountryArguments? get() => RouteArgumentsProvider.get<SelectCountryArguments>();
}
