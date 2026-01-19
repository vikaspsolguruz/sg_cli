import 'package:flutter/material.dart';
import 'package:max_arch/core/constants/app_strings.dart';
import 'package:max_arch/core/theme/text_style/app_text_styles.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:max_arch/presentation/widgets/otp/otp_controller.dart';

typedef OtpTimerBuilder =
    Widget Function(
      BuildContext context,
      int remainingSeconds,
      String formattedTime,
    );

typedef OtpResendButtonBuilder =
    Widget Function(
      BuildContext context,
      VoidCallback onTap,
      bool enabled,
    );

class OtpResendWidget extends StatelessWidget {
  const OtpResendWidget({
    super.key,
    required this.controller,
    this.timerBuilder,
    this.resendButtonBuilder,
    this.timerPrefix,
    this.resendText,
    this.spacing = 4,
  });

  final OtpController controller;
  final OtpTimerBuilder? timerBuilder;
  final OtpResendButtonBuilder? resendButtonBuilder;
  final String? timerPrefix;
  final String? resendText;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.state == OtpState.countdown) {
          return timerBuilder?.call(
                context,
                controller.remainingSeconds,
                controller.formatTime(),
              ) ??
              _DefaultTimerWidget(
                formattedTime: controller.formatTime(),
                prefix: timerPrefix,
              );
        }

        return resendButtonBuilder?.call(
              context,
              controller.resend,
              controller.canResend && !controller.isLoading,
            ) ??
            _DefaultResendButton(
              onTap: controller.resend,
              enabled: controller.canResend && !controller.isLoading,
              text: resendText,
            );
      },
    );
  }
}

class _DefaultTimerWidget extends StatelessWidget {
  const _DefaultTimerWidget({
    required this.formattedTime,
    this.prefix,
  });

  final String formattedTime;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${prefix ?? AppStrings.resendCodeIn} $formattedTime',
      style: AppTextStyles.p3Regular.copyWith(
        color: context.colors.textNeutralSecondary,
      ),
    );
  }
}

class _DefaultResendButton extends StatelessWidget {
  const _DefaultResendButton({
    required this.onTap,
    required this.enabled,
    this.text,
  });

  final VoidCallback onTap;
  final bool enabled;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Text(
        text ?? AppStrings.resendCode,
        style: AppTextStyles.p3SemiBold.copyWith(
          color: enabled ? context.colors.textBrandPrimary : context.colors.textNeutralDisable,
        ),
      ),
    );
  }
}
