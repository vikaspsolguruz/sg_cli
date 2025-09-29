import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/utils/console_print.dart';

/// Requires [AppIcons]
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.iconPath, {
    super.key,
    this.size,
    this.alignment = Alignment.center,
    this.color,
    this.shouldIgnoreColorFilter = false,
  });

  final String iconPath;
  final double? size;
  final Alignment alignment;
  final Color? color;
  final bool shouldIgnoreColorFilter;

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    if (color == null) {
      iconColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    } else {
      iconColor = color!;
    }
    if (iconPath.endsWith(kSVGExtension)) {
      return SvgPicture.asset(
        iconPath,
        height: size,
        width: size,
        colorFilter: shouldIgnoreColorFilter ? null : ColorFilter.mode(iconColor, BlendMode.srcIn),
        alignment: alignment,
      );
    } else if (iconPath.endsWith(kPNGExtension)) {
      return Image.asset(
        iconPath,
        height: size,
        width: size,
        alignment: alignment,
      );
    } else {
      xErrorPrint('Unknown format of image: $iconPath');
      return const SizedBox.shrink();
    }
  }
}
