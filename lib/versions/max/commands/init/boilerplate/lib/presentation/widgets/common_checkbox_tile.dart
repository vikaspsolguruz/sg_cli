import 'package:flutter/material.dart';
import 'package:max_arch/core/theme/styling/app_colors.dart';
import 'package:max_arch/core/utils/extensions.dart';

class CommonCheckboxTile extends StatelessWidget {
  const CommonCheckboxTile({
    super.key,
    this.title,
    this.subtitle,
    this.secondary,
    required this.value,
    this.onChanged,
    this.contentPadding,
    this.controlAffinity = ListTileControlAffinity.trailing,
    this.checkBoxFillColor,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.borderRadius = 0,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final ListTileControlAffinity? controlAffinity;
  final CrossAxisAlignment crossAxisAlignment;
  final WidgetStateProperty<Color?>? checkBoxFillColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final checkBox = IgnorePointer(
      child: Transform.scale(
        scale: 1.1,
        child: Checkbox(
          value: value,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: BorderSide(color: context.colors.strokeNeutralLight200, width: 1.5),
          fillColor: checkBoxFillColor,
        ),
      ),
    );
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: () {
        onChanged?.call(!value);
      },
      child: Container(
        padding: contentPadding,
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (controlAffinity == ListTileControlAffinity.leading) ...[
              checkBox,
              const SizedBox(
                width: 8,
              ),
            ],
            if (title != null)
              Expanded(
                child: title!,
              ),
            if (secondary != null) secondary!,
            if (controlAffinity == ListTileControlAffinity.trailing) checkBox,
          ],
        ),
      ),
    );
  }
}
