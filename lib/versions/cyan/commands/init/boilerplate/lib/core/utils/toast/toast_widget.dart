import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/theme/styling/app_colors.dart';
import 'package:newarch/core/theme/text_style/app_text_styles.dart';

class ToastWidget extends StatefulWidget {
  const ToastWidget({
    required this.message,
    required this.removeNotification,
    this.isPositive = true,
    this.iconData,
    super.key,
    required this.duration,
    this.isPersistent = false,
    this.showLoader = false,
  });

  final String message;
  final bool isPositive;
  final Duration duration;
  final IconData? iconData;
  final bool isPersistent;
  final bool showLoader;
  final VoidCallback removeNotification;

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    startAnimation();
    super.initState();
    if (!widget.isPersistent) {
      Future.delayed(
        widget.duration,
        () {
          if (mounted) {
            _controller.reverse().then((value) {
              widget.removeNotification();
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(
          begin: 0.85,
          end: 1,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn),
        );

    _fadeAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn),
        );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isPositive ? Colors.green.shade600 : Colors.red.shade600;
    return Material(
      type: MaterialType.transparency,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kHorizontalPadding),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: widget.isPositive
                  //         ? Colors.grey.withOpacity(0.5)
                  //         : Colors.red.withOpacity(
                  //             0.3,
                  //           ),
                  //     spreadRadius: 3,
                  //     blurRadius: 7,
                  //     offset: const Offset(0, 3), // changes position of shadow
                  //   ),
                  // ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.iconData != null) ...[
                      Icon(
                        widget.iconData,
                        color: AppColors.shadesWhite,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ] else if (widget.showLoader) ...[
                      SizedBox(
                        height: 20,
                        child: FittedBox(
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            strokeCap: StrokeCap.round,
                            color: AppColors.shadesWhite,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Flexible(
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.p3Medium.withColor(AppColors.shadesWhite),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
