part of 'select_country_bloc.dart';

class SelectCountryState extends Equatable {
  final List<CountryCode> countries;
  final CountryCode? selectedCountry;

  const SelectCountryState({
    this.countries = const [],
    this.selectedCountry,
  });

  factory SelectCountryState.initial() => SelectCountryState(
    selectedCountry: AppState.currentRouteArguments[RouteArguments.selectedCountry],
    countries: const FlCountryCodePicker().countryCodes,
  );

  SelectCountryState copyWith({
    List<CountryCode>? countries,
    CountryCode? selectedCountry,
  }) => SelectCountryState(
    countries: countries ?? this.countries,
    selectedCountry: selectedCountry ?? this.selectedCountry,
  );

  @override
  List<Object?> get props => [
    countries,
    selectedCountry,
  ];

  @override
  String toString() => '$runtimeType';

  @visibleForTesting
  const SelectCountryState.test({
    this.countries = const [],
    this.selectedCountry,
  });
}
