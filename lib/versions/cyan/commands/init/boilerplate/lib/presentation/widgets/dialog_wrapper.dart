import 'package:flutter/material.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/utils/extensions.dart';

class DialogWrapper extends StatefulWidget {
  const DialogWrapper({
    super.key,
    required this.child,
    required this.alignment,
  });

  final AlignmentGeometry alignment;
  final Widget child;

  @override
  State<DialogWrapper> createState() => _DialogWrapperState();
}

class _DialogWrapperState extends State<DialogWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeArea = context.padding;
    final horizontalPadding = (safeArea.horizontal + 16).clamp(16, double.infinity).toDouble();
    final verticalPadding = (safeArea.vertical + 32).clamp(32, double.infinity).toDouble();

    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Material(
                borderRadius: BorderRadius.circular(kBorderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(kInnerHorizontalPadding),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
