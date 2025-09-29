import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/presentation/bottom_sheets/select_country/logic/select_country_bloc.dart';

class SelectCountryList extends StatefulWidget {
  const SelectCountryList({super.key});

  @override
  State<SelectCountryList> createState() => _SelectCountryListState();
}

class _SelectCountryListState extends State<SelectCountryList> {
  late final bloc = context.selectCountryBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectCountryBloc, SelectCountryState>(
      buildWhen: (previous, current) => previous.countries != current.countries,
      builder: (context, state) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          sliver: SliverList.builder(
            itemCount: state.countries.length,
            itemBuilder: (context, index) {
              final country = state.countries[index];
              final isSelected = country.code == state.selectedCountry?.code;
              return ListTile(
                selectedColor: context.colors.bgBrandHover,
                onTap: () => bloc.add(SelectCountry(country)),
                selected: isSelected,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: country.flagImage(width: 24),
                ),
                title: Text(
                  "${country.name} (${country.dialCode})",
                  style: AppTextStyles.p2Regular.copyWith(
                    color: isSelected ? context.colors.textBrandSecondary : context.colors.textNeutralPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
