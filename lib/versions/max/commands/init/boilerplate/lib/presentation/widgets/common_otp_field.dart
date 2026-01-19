import 'package:flutter/material.dart';
import 'package:max_arch/core/theme/text_style/app_text_styles.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:sms_autodetect/sms_autodetect.dart';

class CommonOtpField extends StatefulWidget {
  const CommonOtpField({
    super.key,
    this.validator,
    this.controller,
    this.hasError = false,
    this.onCompleted,
  });

  final String? Function(String?)? validator;

  final TextEditingController? controller;
  final bool hasError;
  final void Function(String val)? onCompleted;

  @override
  State<CommonOtpField> createState() => _CommonOtpFieldState();
}

class _CommonOtpFieldState extends State<CommonOtpField> {
  final fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final contentWidth = (context.width - 82).clamp(1, 450);
    final fieldWidth = contentWidth / 6;
    final fieldHeight = fieldWidth * 1.1;
    final hasError = widget.validator?.call(widget.controller?.text) != null;

    return PinCodeTextField(
      key: fieldKey,
      autoDisposeControllers: false,
      hintCharacter: '-',
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: widget.validator,
      appContext: context,
      errorTextSpace: fieldHeight / 2,
      length: 6,
      boxShadows: const [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Color(0x181B250A),
        ),
      ],
      animationType: AnimationType.fade,

      textStyle: AppTextStyles.h4Medium.copyWith(color: context.colors.shadesBlack, height: 36 / 28),
      controller: widget.controller,
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
        selectedColor: hasError ? context.colors.iconErrorHover : context.colors.iconNeutralPressed,
        selectedFillColor: context.colors.bgShadesWhite,
        inactiveColor: context.colors.strokeNeutralLight200,
        activeColor: hasError ? context.colors.iconErrorHover : context.colors.iconNeutralPressed,
      ),
      cursorColor: context.colors.shadesBlack,
      cursorHeight: 20,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      mainAxisAlignment: MainAxisAlignment.center,
      onCompleted: widget.onCompleted,
      onChanged: (value) {
        if (value.isEmpty) {
          FocusManager.instance.primaryFocus?.unfocus();
          return;
        }
        setState(() {});
      },
      beforeTextPaste: (text) {
        return false;
      },
    );
  }
}
