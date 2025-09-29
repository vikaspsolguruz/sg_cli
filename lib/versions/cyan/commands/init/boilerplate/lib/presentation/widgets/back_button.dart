import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:newarch/core/utils/extensions.dart';

class CommonBackButton extends StatelessWidget {
  const CommonBackButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
        onPressed: onPressed ?? () => context.pop(),
        splashRadius: kTextTabBarHeight / 2,
        padding: EdgeInsets.zero,
        icon: Icon(
          TablerIcons.arrow_left,
          color: context.isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
