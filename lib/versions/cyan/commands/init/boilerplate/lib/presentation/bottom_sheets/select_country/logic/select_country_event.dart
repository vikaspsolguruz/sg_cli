part of 'select_country_bloc.dart';

abstract class SelectCountryEvent extends BaseEvent {
  const SelectCountryEvent();
}

class SelectCountry extends SelectCountryEvent {
  final CountryCode selectedCountry;

  const SelectCountry(this.selectedCountry);

  @override
  Map<String, dynamic> getAnalyticParameters() => {
    'country': selectedCountry.code,
  };

  @override
  List<Object?> get props => [];
}

class SearchCountry extends SelectCountryEvent {
  final String searchText;

  const SearchCountry(this.searchText);

  @override
  Map<String, dynamic> getAnalyticParameters() => {
    'searchText': searchText,
  };

  @override
  List<Object?> get props => [];
}
