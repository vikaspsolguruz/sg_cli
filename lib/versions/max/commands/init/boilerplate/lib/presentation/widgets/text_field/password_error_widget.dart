import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:max_arch/core/data/password_validations.dart';
import 'package:max_arch/core/theme/styling/app_colors.dart';
import 'package:max_arch/core/theme/text_style/app_text_styles.dart';
import 'package:max_arch/core/utils/extensions.dart';

class PasswordErrorWidget extends StatelessWidget {
  const PasswordErrorWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: passwordValidations.map(
        (e) {
          return Row(
            children: [
              Icon(
                TablerIcons.circle_check_filled,
                size: 16,
                color: e.isValid(text) ? context.colors.bgSuccessHover : context.colors.bgNeutralLight200,
              ),
              const SizedBox(width: 4),
              Text(
                e.errorMessage,
                style: AppTextStyles.p4Medium.copyWith(
                  color: e.isValid(text) ? context.colors.textSuccessSecondary : context.colors.textNeutralSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ).toList(),
    );
  }
}
