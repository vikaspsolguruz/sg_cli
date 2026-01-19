import 'package:flutter/material.dart';
import 'package:max_arch/core/theme/text_style/app_text_styles.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:max_arch/presentation/widgets/back_button.dart';

class CommonSliverAppbar extends StatelessWidget {
  const CommonSliverAppbar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.leading,
    this.bottom,
    this.centerTitle = true,
    this.height = kTextTabBarHeight,
    this.pinned = true,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double height;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      title: titleWidget ?? (title != null ? Text(title!, style: AppTextStyles.p1Medium) : null),
      leading: leading ?? (context.canPop ? const CommonBackButton() : null),
      actions: actions,
      bottom: bottom,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      elevation: elevation,
      toolbarHeight: height,
    );
  }
}
