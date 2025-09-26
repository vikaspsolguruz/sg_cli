import 'package:flutter/material.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/presentation/widgets/back_button.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppbar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.leading,
    this.bottom,
    this.centerTitle = true,
    this.height,
    this.titleSpacing,
    this.leadingWidth,
    this.show = true,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double? height;
  final double? titleSpacing;
  final double? leadingWidth;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      child: show
          ? AppBar(
              title: titleWidget ?? (title != null ? Text(title!, style: context.theme.appBarTheme.titleTextStyle) : null),
              leading: leading ?? (context.canPop ? const BackButtonWidget() : null),
              actions: actions,
              bottom: bottom,
              leadingWidth: leadingWidth,
              titleSpacing: titleSpacing,
              backgroundColor: backgroundColor,
              surfaceTintColor: Colors.transparent,
              centerTitle: centerTitle,
              elevation: elevation,
              toolbarHeight: height,
            )
          : const SizedBox(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
