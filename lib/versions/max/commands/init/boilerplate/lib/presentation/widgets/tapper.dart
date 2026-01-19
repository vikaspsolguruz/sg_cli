import 'package:flutter/material.dart';

class Tapper extends StatelessWidget {
  const Tapper({
    super.key,
    this.onTap,
    this.decoration,
    this.padding = EdgeInsets.zero,
    required this.child,
  });

  final void Function()? onTap;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tapArea = InkWell(
      splashFactory: decoration == null ? NoSplash.splashFactory : null,
      highlightColor: decoration == null ? Colors.transparent : null,
      focusColor: decoration == null ? Colors.transparent : null,
      borderRadius: decoration?.borderRadius?.resolve(null),
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    );
    return decoration != null
        ? Material(
            color: decoration?.color,
            shape: RoundedRectangleBorder(
              borderRadius: decoration?.borderRadius ?? BorderRadius.zero,
              side: decoration?.border == null
                  ? BorderSide.none
                  : BorderSide(
                      color: decoration?.border?.top.color ?? Colors.transparent,
                      width: decoration?.border?.top.width ?? 0,
                    ),
            ),
            child: tapArea,
          )
        : tapArea;
  }
}
