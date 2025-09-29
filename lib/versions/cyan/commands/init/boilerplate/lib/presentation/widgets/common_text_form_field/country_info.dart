import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:newarch/app/app_routes/_route_names.dart';
import 'package:newarch/app/app_routes/route_arguments.dart';
import 'package:newarch/app/navigation/navigator.dart';

import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';
import 'package:newarch/core/utils/extensions.dart';

class CountryInfo extends StatelessWidget {
  const CountryInfo({
    super.key,
    required this.selectedCountry,
    required this.onSelectCountry,
    required this.canTap,
  });

  final CountryCode selectedCountry;
  final void Function(CountryCode country) onSelectCountry;
  final bool canTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canTap
          ? () async {
              final result = await Go.openBottomSheet(Routes.selectCountry, arguments: {RouteArguments.selectedCountry: selectedCountry});
              if (result is CountryCode) onSelectCountry(result);
            }
          : null,
      child: Container(
        width: 92,
        margin: const EdgeInsets.fromLTRB(1, 1, 12, 1),
        height: 54,
        decoration: BoxDecoration(
          color: context.colors.strokeNeutralLight50,
          border: Border(right: BorderSide(color: context.colors.strokeNeutralLight200)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(kBorderRadius),
            bottomLeft: Radius.circular(kBorderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                color: context.colors.bgShadesWhite,
                child: selectedCountry.flagImage(width: 20, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                selectedCountry.dialCode,
                style: AppTextStyles.p3Medium.copyWith(color: context.colors.textNeutralPrimary),
              ),
            ),
            Icon(TablerIcons.chevron_down, color: context.colors.textNeutralDisable, size: 16),
          ],
        ),
      ),
    );
  }
}
