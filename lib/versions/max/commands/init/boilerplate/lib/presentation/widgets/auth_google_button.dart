import 'package:flutter/material.dart';
import 'package:max_arch/gen/assets.gen.dart';
import 'package:max_arch/presentation/widgets/app_button/app_button.dart';

class AuthGoogleButton extends StatelessWidget {
  final String label;
  final AppButtonController? authButtonController;
  final dynamic Function()? onTap;

  const AuthGoogleButton({
    super.key,
    required this.label,
    required this.onTap,
    this.authButtonController,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      controller: authButtonController,
      size: AppButtonSize.xl,
      fillWidth: true,
      label: label,
      leftSvgIcon: Assets.images.svg.google,
      style: AppButtonStyle.outline,
      onPressed: onTap,
      isExpandLabel: true,
      elevation: 4,
    );
  }
}
