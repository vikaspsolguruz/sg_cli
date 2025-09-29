import 'package:flutter/material.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/gen/assets.gen.dart';
import 'package:newarch/presentation/widgets/app_button/app_button.dart';

class AuthAppleButton extends StatelessWidget {
  final String label;
  final dynamic Function()? onTap;
  final AppButtonController? authButtonController;

  const AuthAppleButton({
    super.key,
    required this.label,
    required this.onTap,
    this.authButtonController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kVerticalPadding),
      child: AppButton(
        size: AppButtonSize.xl,
        fillWidth: true,
        label: label,
        leftSvgIcon: Assets.images.svg.apple,
        style: AppButtonStyle.outline,
        onPressed: onTap,
        controller: authButtonController,
        isExpandLabel: true,
        elevation: 4,
      ),
    );
  }
}
