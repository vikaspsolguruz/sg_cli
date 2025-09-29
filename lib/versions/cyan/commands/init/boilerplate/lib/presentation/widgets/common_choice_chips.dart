import 'package:flutter/material.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/presentation/widgets/app_button/app_button.dart';
import 'package:newarch/presentation/widgets/common_form_label.dart';

class CommonChoiceChips<T> extends StatelessWidget {
  final T? selectedItem;
  final List<T> allItems;
  final String Function(T item) getLabel;
  final void Function(T item) onChanged;
  final String? label;
  final bool isRequired;
  final double? height;
  final double? switchRadius;
  final AppButtonSize appButtonSize;
  final bool isScrollable;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final bool readOnly;
  final Color? selectedBorderColor;
  final Color? selectedBgColor;
  final EdgeInsets? labelPadding;

  const CommonChoiceChips({
    super.key,
    required this.selectedItem,
    required this.allItems,
    required this.getLabel,
    required this.onChanged,
    this.label,
    this.isRequired = false,
    this.height = 44,
    this.appButtonSize = AppButtonSize.s,
    this.switchRadius = 22,
    this.isScrollable = false,
    this.spacing = 16,
    this.padding,
    this.readOnly = false,
    this.selectedBorderColor,
    this.selectedBgColor,
    this.labelPadding,
  });

  const CommonChoiceChips.small({
    super.key,
    required this.selectedItem,
    required this.allItems,
    required this.getLabel,
    required this.onChanged,
    this.label,
    this.isRequired = false,
    this.height,
    this.appButtonSize = AppButtonSize.m,
    this.switchRadius = 48,
    this.isScrollable = false,
    required this.spacing,
    this.padding,
    this.readOnly = false,
    this.selectedBorderColor,
    this.selectedBgColor,
    this.labelPadding,
  });

  const CommonChoiceChips.extraSmall({
    super.key,
    required this.selectedItem,
    required this.allItems,
    required this.getLabel,
    required this.onChanged,
    this.label,
    this.isRequired = false,
    this.height = 36,
    this.appButtonSize = AppButtonSize.m,
    this.switchRadius = 48,
    this.isScrollable = false,
    required this.spacing,
    this.padding,
    this.readOnly = false,
    this.selectedBorderColor,
    this.selectedBgColor,
    this.labelPadding,
  });

  @override
  Widget build(BuildContext context) {
    final rowWidget = Row(
      spacing: spacing,
      children: List.generate(
        allItems.length,
        (index) {
          final item = allItems[index];
          final switchButton = IgnorePointer(
            ignoring: readOnly,
            child: _SwitchButton(
              padding: labelPadding,
              heightOverride: height,
              appButtonSize: appButtonSize,
              switchRadius: switchRadius,
              isSelected: item == selectedItem,
              text: getLabel(item),
              onPressed: () => onChanged(item),
              selectedBorderColor: selectedBorderColor ?? greenSecondary.shade700,
              selectedBgColor: selectedBgColor ?? greenSecondary.shade50,
              readOnly: readOnly,
            ),
          );
          return isScrollable ? switchButton : Expanded(child: switchButton);
        },
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: CommonFormLabel(labelText: label!, isRequired: isRequired),
          ),
        if (isScrollable)
          SingleChildScrollView(
            padding: padding,
            scrollDirection: Axis.horizontal,
            child: rowWidget,
          )
        else
          rowWidget,
      ],
    );
  }
}

class _SwitchButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function() onPressed;
  final AppButtonSize appButtonSize;
  final double? switchRadius;
  final double? heightOverride;
  final Color selectedBorderColor;
  final Color selectedBgColor;
  final EdgeInsets? padding;
  final bool readOnly;

  const _SwitchButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
    required this.appButtonSize,
    this.switchRadius,
    this.heightOverride,
    this.padding,
    required this.selectedBorderColor,
    required this.selectedBgColor,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? selectedBorderColor
        : readOnly
        ? neutral.shade200
        : neutral.shade200;
    final bgColor = isSelected
        ? selectedBgColor
        : readOnly
        ? context.colors.bgNeutralLight100
        : context.colors.shadesWhite;
    return AppButton(
      onPressed: onPressed,
      heightOverride: heightOverride,
      style: AppButtonStyle.outline,
      bgColorOverride: bgColor,
      radiusOverride: switchRadius,
      size: appButtonSize,
      label: text,
      iconOrTextColorOverride: isSelected || (!readOnly) ? context.colors.textNeutralPrimary : context.colors.textNeutralSecondary,
      borderColorOverride: borderColor,
      padding: padding,
    );
  }
}
