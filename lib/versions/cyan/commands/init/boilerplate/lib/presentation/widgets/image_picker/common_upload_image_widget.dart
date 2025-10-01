import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/presentation/widgets/app_button/app_button.dart';

class CommonUploadImageWidget extends StatelessWidget {
  const CommonUploadImageWidget({
    super.key,
    this.onTap,
    this.height = 235,
    this.hasError = false,
    this.message,
  });

  final void Function()? onTap;
  final double height;
  final bool hasError;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: hasError ? context.colors.textErrorSecondary : context.colors.strokeNeutralLight200,
        strokeWidth: 2,
        radius: const Radius.circular(10),
      ),

      child: Container(
        padding: const EdgeInsets.all(16),
        height: height - 4,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(TablerIcons.file_upload, color: context.colors.strokeNeutralHover),
            const SizedBox(height: kVerticalPadding),
            Text(AppStrings.chooseAFile, style: AppTextStyles.p3Medium),
            const SizedBox(height: 4),
            Text(message ?? AppStrings.supportedExtensionAndSizeMessage, style: AppTextStyles.p4Regular, textAlign: TextAlign.center),
            const SizedBox(height: kVerticalPadding),
            AppButton(
              onPressed: onTap,
              heightOverride: 36,
              width: 140,
              size: AppButtonSize.xs,
              label: AppStrings.browseFiles,
              iconOrTextColorOverride: context.colors.textBrandSecondary,
              leftIconColor: context.colors.strokeBrandDefault,
              leftIconData: TablerIcons.folders,
              bgColorOverride: context.colors.bgBrandLight50,
            ),
          ],
        ),
      ),
    );
  }
}
