import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    super.key,
    this.overlay,
    this.color,
    this.child,
    this.borderRadius = 0,
    this.blur = 10,
    required this.width,
    required this.height,
  });

  final Widget? overlay;
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final double blur;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Blur(
        colorOpacity: 0.2,
        blur: blur,
        blurColor: color ?? Colors.transparent,
        overlay: child,
        borderRadius: BorderRadius.circular(borderRadius),
        child: overlay ?? const SizedBox.shrink(),
      ),
    );
  }
}
