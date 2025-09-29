import 'package:flutter/material.dart';
import 'package:newarch/app/app_state.dart';
import 'package:sizer/sizer.dart';

import 'toast_widget.dart';

class Toast {
  Toast._();

  static final List<OverlayEntry?> _overlayEntries = List.empty(growable: true);

  static bool get isActive => _overlayEntries.isNotEmpty;

  static String? get currentMessage => isActive ? _currMsg : null;

  static String? _currMsg;

  static bool show(
    String? message, {
    bool isPositive = true,
    bool closeAllPrevious = true,
    Duration duration = const Duration(seconds: 2),
    IconData? icon,
    bool isPersistent = false,
    bool showLoader = false,
  }) {
    if (message == null) return false;
    if (AppState.rootNavigatorKey.currentState != null) {
      _currMsg = message;
      final overlay = AppState.rootNavigatorKey.currentState!.overlay;
      final entry = _createOverlayEntry(
        message,
        isPositive: isPositive,
        duration: duration,
        icon: icon,
        showLoader: showLoader,
        isPersistent: isPersistent,
      );
      if (closeAllPrevious) _closeAll();
      _overlayEntries.add(entry);
      overlay?.insert(entry);
      return true;
    }
    return false;
  }

  static OverlayEntry _createOverlayEntry(
    String message, {
    required bool isPositive,
    required Duration duration,
    IconData? icon,
    bool isPersistent = false,
    bool showLoader = false,
  }) {
    return OverlayEntry(
      builder: (context) {
        return Align(
          alignment: Alignment.topCenter,
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 60.w),
              child: ToastWidget(
                message: message,
                iconData: icon,
                removeNotification: removeNotification,
                isPositive: isPositive,
                duration: duration,
                isPersistent: isPersistent,
                showLoader: showLoader,
              ),
            ),
          ),
        );
      },
    );
  }

  static void removeNotification() {
    if (_overlayEntries.isNotEmpty) {
      _overlayEntries.first?.remove();
      _overlayEntries.removeAt(0);
    }
  }

  static void _closeAll() {
    if (_overlayEntries.isNotEmpty) {
      for (final entry in _overlayEntries) {
        entry?.remove();
      }
      _overlayEntries.clear();
    }
  }
}
