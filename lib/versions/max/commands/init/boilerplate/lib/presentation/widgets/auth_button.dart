import 'package:flutter/material.dart';
import 'package:max_arch/presentation/widgets/app_button/app_button.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final AppButtonController? controller;
  final dynamic Function()? onTap;
  final String leftIcon;

  const AuthButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.leftIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      controller: controller,
      size: ButtonSize.xl,
      fillWidth: true,
      label: label,
      leftIcon: leftIcon,
      variant: ButtonVariant.outline,
      onPressed: onTap,
      expandLabel: true,
      elevation: 4,
    );
  }
}
