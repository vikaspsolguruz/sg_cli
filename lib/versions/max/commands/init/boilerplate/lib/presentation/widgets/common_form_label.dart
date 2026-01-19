import 'package:flutter/material.dart';
import 'package:max_arch/core/constants/app_strings.dart';
import 'package:max_arch/core/theme/styling/app_colors.dart';
import 'package:max_arch/core/theme/text_style/app_text_styles.dart';
import 'package:max_arch/core/utils/extensions.dart';

class CommonFormLabel extends StatelessWidget {
  const CommonFormLabel({super.key, required this.labelText, this.isRequired = false});

  final String labelText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: labelText,
            style: AppTextStyles.p3Medium.copyWith(color: context.colors.textNeutralPrimary),
          ),
          if (isRequired)
            TextSpan(
              text: AppStrings.asterisk.tr,
              style: AppTextStyles.p3Medium.copyWith(color: context.colors.textErrorSecondary),
            ),
        ],
      ),
    );
  }
}
