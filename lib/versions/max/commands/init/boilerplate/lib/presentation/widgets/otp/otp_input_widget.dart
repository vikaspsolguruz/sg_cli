import 'package:flutter/material.dart';
import 'package:max_arch/core/theme/text_style/app_text_styles.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:max_arch/presentation/widgets/otp/otp_controller.dart';
import 'package:sms_autodetect/sms_autodetect.dart';

class OtpInputWidget extends StatelessWidget {
  const OtpInputWidget({
    super.key,
    required this.controller,
    this.obscureText = false,
    this.showCursor = true,
    this.readOnly = false,
  });

  final OtpController controller;
  final bool obscureText;
  final bool showCursor;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final contentWidth = (context.width - 82).clamp(1, 450);
        final fieldWidth = contentWidth / controller.otpLength;
        final fieldHeight = fieldWidth * 1.1;
        final hasError = controller.errorMessage != null;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PinCodeTextField(
              autoDisposeControllers: false,
              hintCharacter: '-',
              autovalidateMode: AutovalidateMode.disabled,
              appContext: context,
              errorTextSpace: 0,
              length: controller.otpLength,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Color(0x181B250A),
                ),
              ],
              animationType: AnimationType.fade,
              textStyle: AppTextStyles.h4Medium.copyWith(
                color: context.colors.shadesBlack,
                height: 36 / 28,
              ),
              controller: controller.textController,
              pinTheme: PinTheme(
                fieldOuterPadding: const EdgeInsets.only(right: 8),
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: fieldHeight,
                fieldWidth: fieldWidth,
                borderWidth: 1,
                errorBorderColor: context.colors.iconErrorHover,
                activeFillColor: context.colors.bgShadesWhite,
                inactiveFillColor: context.colors.bgShadesWhite,
                selectedColor: hasError
                    ? context.colors.iconErrorHover
                    : context.colors.iconNeutralPressed,
                selectedFillColor: context.colors.bgShadesWhite,
                inactiveColor: hasError
                    ? context.colors.iconErrorHover
                    : context.colors.strokeNeutralLight200,
                activeColor: hasError
                    ? context.colors.iconErrorHover
                    : context.colors.iconNeutralPressed,
              ),
              cursorColor: context.colors.shadesBlack,
              cursorHeight: 20,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              mainAxisAlignment: MainAxisAlignment.center,
              obscureText: obscureText,
              showCursor: showCursor,
              readOnly: readOnly || controller.isLoading,
              onCompleted: controller.onCompleted,
              onChanged: (value) {
                if (value.isEmpty) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              beforeTextPaste: (_) => false,
            ),
            if (hasError) ...[
              const SizedBox(height: 8),
              Text(
                controller.errorMessage!,
                style: AppTextStyles.p4Regular.copyWith(
                  color: context.colors.textErrorSecondary,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}