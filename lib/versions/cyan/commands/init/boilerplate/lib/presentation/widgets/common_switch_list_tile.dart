import 'package:flutter/material.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';

class CommonSwitchListTile extends StatelessWidget {
  final void Function(bool value) onChanged;
  final bool isEnabled;
  final String? title;
  final Widget? titleWidget;

  const CommonSwitchListTile({
    super.key,
    required this.onChanged,
    required this.isEnabled,
    this.title,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      contentPadding: EdgeInsets.zero,
      inactiveThumbColor: AppColors.bgShadesWhite,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      inactiveTrackColor: AppColors.bgNeutralLight200,
      controlAffinity: ListTileControlAffinity.leading,
      title:
          titleWidget ??
          Text(
            title ?? '',
            style: AppTextStyles.p3Medium.withColor(AppColors.textNeutralPrimary),
          ),
      onChanged: onChanged,
      value: isEnabled,
    );
  }
}
