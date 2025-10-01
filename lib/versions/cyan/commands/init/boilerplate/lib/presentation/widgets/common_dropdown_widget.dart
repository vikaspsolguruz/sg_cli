import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/presentation/widgets/common_form_label.dart';
import 'package:newarch/presentation/widgets/tapper.dart';

class CommonDropDownWidget<T> extends StatefulWidget {
  const CommonDropDownWidget({
    super.key,
    required this.items,
    this.width,
    this.dropDownLabel,
    this.focusNode,
    this.icon,
    this.autofocus = true,
    this.textStyle,
    required this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.dropdownPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = false,
    this.isRequired = false,
    this.validator,
    this.onChanged,
    this.alignment,
    this.menuMaxHeight,
    this.onTap,
    required this.getName,
    this.value,
  });

  final String? dropDownLabel;
  final List<T> items;
  final double? width;
  final FocusNode? focusNode;
  final Widget? icon;
  final bool autofocus;
  final TextStyle? textStyle;
  final String hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding, dropdownPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool filled;
  final bool isRequired;
  final String? Function(T? val)? validator;
  final Function(T? val)? onChanged;
  final Alignment? alignment;
  final double? menuMaxHeight;
  final Function()? onTap;
  final String Function(T value)? getName;
  final T? value;

  @override
  State<CommonDropDownWidget<T>> createState() => _CommonDropDownWidgetState<T>();
}

class _CommonDropDownWidgetState<T> extends State<CommonDropDownWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.dropDownLabel != null || (widget.dropDownLabel?.isNotEmpty ?? false)) ...[dropDownLabel(), const SizedBox(height: 6)],
        widget.alignment != null ? Align(alignment: widget.alignment ?? Alignment.center, child: dropDownWidget) : dropDownWidget,
      ],
    );
  }

  Widget get dropDownWidget => Tapper(
    onTap: widget.onTap,
    child: DropdownButtonFormField2<T>(
      value: widget.value,
      isExpanded: true,
      dropdownStyleData: DropdownStyleData(
        elevation: 16,
        maxHeight: widget.menuMaxHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      iconStyleData: IconStyleData(
        icon: widget.icon ?? Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: context.colors.strokeNeutralDisabled),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.zero,
        height: 56,
      ),
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(color: context.colors.strokeNeutralLight200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(color: context.colors.strokeNeutralLight200),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(color: context.colors.strokeErrorDefault),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(color: context.colors.strokeErrorDefault),
        ),
        contentPadding: widget.dropdownPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      hint: Text(
        widget.hintText,
        style: widget.hintStyle ?? AppTextStyles.p2Medium.copyWith(fontSize: 16, color: context.colors.textNeutralDisable),
      ),
      disabledHint: Text(
        widget.hintText,
        style: AppTextStyles.p2Medium.copyWith(
          fontSize: 16,
          color: context.colors.textNeutralDisable,
        ),
      ),
      style: widget.textStyle ?? AppTextStyles.p2Medium.copyWith(fontSize: 16, color: context.colors.textNeutralPrimary),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.isRequired ? widget.validator : null,
      onChanged: (T? newValue) {
        if (newValue != null) {
          widget.onChanged?.call(newValue);
        }
      },
      selectedItemBuilder: (BuildContext context) {
        return widget.items.map<Widget>((T value) {
          return Text(
            widget.getName != null ? widget.getName!(value) : "",
            style: widget.textStyle ?? AppTextStyles.p2Medium.copyWith(fontSize: 16, color: context.colors.textNeutralPrimary),
            overflow: TextOverflow.ellipsis, // Optional: avoid overflow
          );
        }).toList();
      },
      items: widget.items.map<DropdownMenuItem<T>>((T value) {
        final isSelected = widget.value == value;
        return DropdownMenuItem<T>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(widget.getName != null ? widget.getName!(value) : "", overflow: TextOverflow.ellipsis)),
                if (isSelected) const Icon(TablerIcons.check, size: 24),
              ],
            ),
          ),
        );
      }).toList(),
      // Important: omit selectedItemBuilder if you want the default selected value rendering
    ),
  );

  InputDecoration get decoration => InputDecoration(
    hintText: widget.hintText,
    hintStyle: widget.hintStyle ?? AppTextStyles.p3Regular.copyWith(color: context.colors.textNeutralDisable, fontSize: 15),
    prefixIcon: widget.prefix,
    prefixIconConstraints: widget.prefixConstraints,
    suffixIcon: widget.suffix,
    suffixIconConstraints: widget.suffixConstraints,
    isDense: true,
    contentPadding: widget.contentPadding,
    fillColor: widget.fillColor,
    filled: widget.filled,
    border: widget.borderDecoration,
    enabledBorder: widget.borderDecoration ?? const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
    focusedBorder: widget.borderDecoration ?? const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
  );

  Widget dropDownLabel() {
    return CommonFormLabel(labelText: widget.dropDownLabel!, isRequired: widget.isRequired);
  }
}
