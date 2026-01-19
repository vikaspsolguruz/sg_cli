import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_arch/app/app_routes/route_arguments.dart';
import 'package:max_arch/app/navigation/navigator.dart';
import 'package:max_arch/core/utils/bloc/base_bloc.dart';
import 'package:max_arch/core/utils/bloc/base_event.dart';
import 'package:max_arch/core/utils/bloc/base_state.dart';
import 'package:max_arch/presentation/widgets/text_field/common_text_field_controller.dart';

part 'select_country_event.dart';
part 'select_country_state.dart';

class SelectCountryBloc extends BaseBloc<SelectCountryEvent, SelectCountryState> {
  SelectCountryBloc() : super(SelectCountryState.initial());

  final TextFieldController searchController = TextFieldController();
  final FlCountryCodePicker _countryPicker = const FlCountryCodePicker();

  @override
  void eventListeners() {
    on<SearchCountry>(_onSearchCountry);
    on<SelectCountry>(_onSelectCountry);
  }

  void _onSearchCountry(SearchCountry event, Emitter<SelectCountryState> emit) {
    final results = _countryPicker.countryCodes
        .where(
          (element) =>
              element.name.toLowerCase().contains(event.searchText.toLowerCase()) ||
              element.dialCode.toLowerCase().contains(event.searchText.toLowerCase()) ||
              element.code.toLowerCase().contains(event.searchText.toLowerCase()),
        )
        .toList();
    emit(state.copyWith(countries: results));
  }

  void _onSelectCountry(SelectCountry event, Emitter<SelectCountryState> emit) {
    Go.back(result: event.selectedCountry);
  }
}

extension SelectCountryExtension on BuildContext {
  SelectCountryBloc get selectCountryBloc => BlocProvider.of<SelectCountryBloc>(this);
}
