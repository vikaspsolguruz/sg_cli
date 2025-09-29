import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/core/utils/input_formatters.dart';
import 'package:newarch/core/utils/validators.dart';
import 'package:newarch/presentation/widgets/common_form_label.dart';
import 'package:newarch/presentation/widgets/common_text_form_field/common_text_field_controller.dart';
import 'package:newarch/presentation/widgets/common_text_form_field/country_info.dart';
import 'package:newarch/presentation/widgets/common_text_form_field/password_error_widget.dart';

enum FieldType {
  none,
  search,
  email,
  password,
  phone,
}

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField({
    super.key,
    required this.textFieldController,
    this.validator,
    this.labelText,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.suffixIcon,
    this.onChanged,
    this.isRequired = false,
    this.hintText,
    this.onTap,
    this.type = FieldType.none,
    this.onTapSuffix,
    this.inputFormatters,
    this.fillColor,
    this.prefixIconData,
    this.suffixIconData,
    this.prefixIconPath,
    this.prefixIcon,
    this.onSubmit,
    this.autoValidate = false,
    this.autofillHints,
    this.maxLength,
    this.enabled = true,
    this.autoFocus = false,
    this.onSaved,
    this.focusNode,
    this.onFocusChanged,
    this.showCounterText = false,
    this.isGreyedOut = false,
    this.isCustomError = false,
    this.onSelectCountry,
    this.selectedCountry,
    this.borderRadius,
    this.minCharactersForValidation,
    this.maxCharactersForValidation,
  });

  const CommonTextFormField.password({
    super.key,
    required this.textFieldController,
    this.validator = Validators.password,
    this.labelText,
    this.keyboardType = TextInputType.visiblePassword,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.type = FieldType.password,
    this.suffixIcon,
    this.onChanged,
    this.isRequired = false,
    this.hintText,
    this.onTap,
    this.onTapSuffix,
    this.inputFormatters,
    this.prefixIconData = TablerIcons.lock,
    this.suffixIconData,
    this.prefixIconPath,
    this.prefixIcon,
    this.onSubmit,
    this.autoValidate = false,
    this.autofillHints = const [AutofillHints.password],
    this.maxLength = 100,
    this.enabled = true,
    this.fillColor,
    this.autoFocus = false,
    this.onSaved,
    this.focusNode,
    this.onFocusChanged,
    this.showCounterText = false,
    this.isGreyedOut = false,
    this.isCustomError = false,
    this.onSelectCountry,
    this.selectedCountry,
    this.borderRadius,
    this.minCharactersForValidation,
    this.maxCharactersForValidation,
  });

  const CommonTextFormField.email({
    super.key,
    required this.textFieldController,
    this.validator = Validators.email,
    this.fillColor,
    this.labelText,
    this.keyboardType = TextInputType.emailAddress,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.type = FieldType.email,
    this.suffixIcon,
    this.onChanged,
    this.isRequired = false,
    this.hintText,
    this.onTap,
    this.onTapSuffix,
    this.inputFormatters,
    this.prefixIconData = TablerIcons.mail,
    this.suffixIconData,
    this.prefixIconPath,
    this.prefixIcon,
    this.onSubmit,
    this.autoValidate = false,
    this.autofillHints = const [AutofillHints.email],
    this.maxLength = 100,
    this.enabled = true,
    this.autoFocus = false,
    this.onSaved,
    this.focusNode,
    this.onFocusChanged,
    this.showCounterText = false,
    this.isGreyedOut = false,
    this.isCustomError = false,
    this.onSelectCountry,
    this.selectedCountry,
    this.borderRadius,
    this.minCharactersForValidation,
    this.maxCharactersForValidation,
  });

  const CommonTextFormField.search({
    super.key,
    required this.textFieldController,
    this.fillColor,
    this.validator,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.search,
    this.suffixIcon,
    this.onChanged,
    this.isRequired = false,
    this.type = FieldType.search,
    this.hintText,
    this.onTap,
    this.onTapSuffix,
    this.inputFormatters,
    this.prefixIconData = TablerIcons.search,
    this.suffixIconData = TablerIcons.x,
    this.prefixIconPath,
    this.prefixIcon,
    this.onSubmit,
    this.autoValidate = false,
    this.autofillHints,
    this.maxLength = 30,
    this.enabled = true,
    this.autoFocus = false,
    this.onSaved,
    this.focusNode,
    this.onFocusChanged,
    this.showCounterText = false,
    this.isGreyedOut = false,
    this.isCustomError = false,
    this.onSelectCountry,
    this.selectedCountry,
    this.borderRadius,
    this.minCharactersForValidation,
    this.maxCharactersForValidation,
  });

  const CommonTextFormField.phone({
    super.key,
    required this.textFieldController,
    this.fillColor,
    this.isCustomError = false,
    this.validator,
    this.labelText,
    this.keyboardType = TextInputType.phone,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.suffixIcon,
    this.onChanged,
    this.isRequired = false,
    this.type = FieldType.phone,
    this.hintText,
    this.onTap,
    this.onTapSuffix,
    this.inputFormatters,
    this.prefixIconData,
    this.suffixIconData,
    this.prefixIconPath,
    this.prefixIcon,
    this.onSubmit,
    this.autoValidate = false,
    this.showCounterText = false,
    this.autofillHints = const [
      AutofillHints.telephoneNumber,
      AutofillHints.telephoneNumberDevice,
      AutofillHints.telephoneNumberLocal,
      AutofillHints.telephoneNumberLocalSuffix,
      AutofillHints.telephoneNumberNational,
    ],
    this.maxLength,
    this.enabled = true,
    this.autoFocus = false,
    this.onSaved,
    this.focusNode,
    this.onFocusChanged,
    this.selectedCountry,
    this.onSelectCountry,
    this.isGreyedOut = false,
    this.borderRadius,
    this.minCharactersForValidation,
    this.maxCharactersForValidation,
  });

  final TextFieldController textFieldController;
  final FieldType type;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool isRequired;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final String? prefixIconPath;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final CountryCode? selectedCountry;
  final void Function(CountryCode country)? onSelectCountry;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final FocusNode? focusNode;
  final Function(bool)? onFocusChanged;
  final bool autoFocus;
  final bool autoValidate;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final void Function()? onTapSuffix;
  final void Function()? onTap;
  final bool isGreyedOut;
  final bool isCustomError;
  final void Function(String val)? onChanged;
  final void Function()? onSaved;
  final Function(String? val)? onSubmit;
  final bool showCounterText;
  final double? borderRadius;
  final int? minCharactersForValidation;
  final int? maxCharactersForValidation;

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  bool obscureText = true;
  bool forcedValidation = false;
  bool hasFocus = false;
  late CountryCode selectedCountry;

  @override
  void initState() {
    widget.textFieldController.focusNode.addListener(focusListener);
    if (widget.type == FieldType.phone) {
      selectedCountry = widget.selectedCountry ?? CountryCode.fromCode('IN')!;
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.textFieldController.focusNode.removeListener(focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          CommonFormLabel(
            labelText: widget.labelText!,
            isRequired: widget.isRequired,
          ),
          const SizedBox(height: 6),
        ],
        AutofillGroup(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 167),
            curve: Curves.fastOutSlowIn,
            alignment: Alignment.topCenter,
            child: TextFormField(
              key: widget.textFieldController.fieldKey,
              readOnly: widget.onTap != null,
              focusNode: widget.textFieldController.focusNode,
              autofocus: widget.autoFocus,
              autofillHints: widget.autofillHints,
              enabled: widget.enabled,
              controller: widget.textFieldController.controller,
              keyboardType: widget.keyboardType,
              onFieldSubmitted: widget.onSubmit,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              textInputAction: widget.textInputAction,
              obscureText: widget.type == FieldType.password ? obscureText : false,
              onEditingComplete: widget.onSaved,
              inputFormatters: getInputFormatters(),
              validator: getValidator(),
              autovalidateMode: widget.autoValidate ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
              onTap: widget.onTap,
              decoration: InputDecoration(
                filled: widget.isGreyedOut || widget.fillColor != null,
                fillColor: widget.isGreyedOut || widget.fillColor != null ? widget.fillColor ?? AppColors.bgNeutralLight50 : null,
                errorMaxLines: 2,
                counterText: widget.showCounterText ? null : '',
                counterStyle: AppTextStyles.c1Medium.copyWith(fontSize: 10, color: AppColors.textNeutralDisable),
                hintText: widget.hintText ?? widget.labelText,
                suffixIcon: _suffixIconBuilder(),
                errorStyle: AppTextStyles.p3Regular.copyWith(color: AppColors.textErrorSecondary, fontSize: widget.isCustomError ? 0 : 12),
                hintStyle: AppTextStyles.p3Medium.copyWith(color: AppColors.textNeutralDisable, height: 1.7, fontWeight: widget.type == FieldType.search ? FontWeight.w400 : null),
                prefixIconConstraints: (widget.prefixIcon ?? widget.prefixIconPath ?? widget.prefixIconData) != null ? null : const BoxConstraints(minWidth: 12),
                suffixIconConstraints: widget.suffixIcon != null ? null : const BoxConstraints(minWidth: 12),
                prefixIcon: _prefixIconBuilder(),
                contentPadding: widget.type == FieldType.phone || widget.type == FieldType.search ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: kVerticalPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? kBorderRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? kBorderRadius),
                  borderSide: BorderSide(color: AppColors.strokeNeutralLight200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? kBorderRadius),
                  borderSide: BorderSide(color: widget.onTap == null ? AppColors.bgBrandHover : AppColors.strokeNeutralLight200),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? kBorderRadius),
                  borderSide: BorderSide(color: AppColors.strokeErrorDefault),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? kBorderRadius),
                  borderSide: BorderSide(color: AppColors.strokeErrorDefault),
                ),
              ),
              onTapOutside: (event) {
                if (event.position.dx < 30 || event.position.dx > context.width - 30) return;
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: (val) {
                if (widget.textFieldController.fieldKey.currentState?.hasInteractedByUser != true) {
                  widget.textFieldController.clear();
                  val = '';
                }
                final changedValidationMode = (val.isNotEmpty || widget.isRequired) != forcedValidation;
                if (changedValidationMode) {
                  toggleForcedValidation();
                } else if (widget.type == FieldType.search) {
                  setState(() {});
                } else if (widget.isCustomError) {
                  setState(() {});
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onChanged?.call(val);
                });
              },
            ),
          ),
        ),
        ?(widget.isCustomError)
            ? Column(
                children: [
                  const SizedBox(height: 8),
                  PasswordErrorWidget(text: widget.textFieldController.controller.text),
                ],
              )
            : null,
      ],
    );
  }

  Widget _prefixIconBuilder() {
    if (widget.prefixIcon != null) {
      return widget.prefixIcon!;
    } else if (widget.type == FieldType.phone) {
      return CountryInfo(
        canTap: widget.onTap == null,
        selectedCountry: selectedCountry,
        onSelectCountry: (CountryCode country) {
          setState(() => selectedCountry = country);
          widget.onSelectCountry?.call(country);
        },
      );
    } else if (widget.prefixIconPath != null) {
      return SvgPicture.asset(
        widget.prefixIconPath!,
        fit: BoxFit.scaleDown,
      );
    } else if (widget.prefixIconData != null) {
      return Icon(
        widget.prefixIconData,
        color: hasFocus || widget.textFieldController.text.isNotEmpty ? AppColors.strokeNeutralDefault : AppColors.strokeNeutralDisabled,
        size: 24,
      );
    }
    return const SizedBox();
  }

  Widget _suffixIconBuilder() {
    if (widget.type == FieldType.search) {
      if (widget.textFieldController.text.isNotEmpty && widget.suffixIconData != null) {
        return IconButton(
          icon: Icon(
            TablerIcons.x,
            color: hasFocus || widget.textFieldController.text.isNotEmpty ? AppColors.strokeNeutralDefault : AppColors.textNeutralDisable,
            size: 24,
          ),
          onPressed: () {
            if (widget.suffixIconData != null) {
              widget.textFieldController.clear();
            }
            widget.onTapSuffix?.call();
            setState(() {});
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onChanged?.call('');
            });
          },
        );
      }
    } else if (widget.type == FieldType.password) {
      return IconButton(
        icon: Icon(
          obscureText ? TablerIcons.eye : TablerIcons.eye_off,
          color: hasFocus || widget.textFieldController.text.isNotEmpty ? AppColors.strokeNeutralDefault : AppColors.textNeutralDisable,
          size: 24,
        ),
        onPressed: () {
          toggleVisibility();
          widget.onTapSuffix?.call();
        },
      );
    } else if (widget.suffixIcon != null) {
      return widget.suffixIcon!;
    } else if (widget.suffixIconData != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIconData,
          color: hasFocus || widget.textFieldController.text.isNotEmpty ? AppColors.strokeNeutralDefault : AppColors.textNeutralDisable,
          size: 24,
        ),
        onPressed: () {
          toggleVisibility();
          widget.onTapSuffix?.call();
        },
      );
    }
    return const SizedBox();
  }

  String? Function(String?)? getValidator() {
    if (forcedValidation || widget.isRequired) {
      if (widget.type == FieldType.phone) {
        return Validators.phoneInternational(country: selectedCountry);
      }
      if (widget.validator != null) {
        return widget.validator;
      }
      return Validators.required(
        widget.textFieldController.text,
        label: widget.labelText,
        isRequired: widget.isRequired,
        minLength: widget.minCharactersForValidation,
        maxLength: widget.maxCharactersForValidation,
      );
    }
    return null;
  }

  List<TextInputFormatter>? getInputFormatters() {
    if (widget.type == FieldType.phone) {
      return InputFormatters.phone(selectedCountry);
    }
    return widget.inputFormatters;
  }

  void toggleVisibility() => setState(() => obscureText = !obscureText);

  void toggleForcedValidation() => setState(() => forcedValidation = !forcedValidation);

  void focusListener() {
    if (widget.onFocusChanged != null) {
      widget.onFocusChanged?.call(widget.textFieldController.focusNode.hasFocus);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => hasFocus = widget.textFieldController.focusNode.hasFocus);
      }
    });
  }
}
