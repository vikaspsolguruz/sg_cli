import 'package:flutter/material.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/presentation/bottom_sheets/select_country/logic/select_country_bloc.dart';
import 'package:newarch/presentation/widgets/common_text_form_field/common_text_form_field.dart';

class SelectCountrySearchBar extends StatelessWidget {
  const SelectCountrySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PinnedHeaderSliver(
      child: Container(
        color: AppColors.shadesWhite,
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: kVerticalPadding),
        child: CommonTextFormField.search(
          hintText: AppStrings.searchCountry,
          textFieldController: context.selectCountryBloc.searchController,
          onChanged: (val) => context.selectCountryBloc.add(SearchCountry(val)),
        ),
      ),
    );
  }
}
