import 'dart:async';

import 'package:flutter/material.dart';

enum OtpState { idle, countdown, expired }

class OtpController extends ChangeNotifier {
  OtpController({
    this.otpLength = 6,
    this.timerDuration = 60,
    this.onCompleted,
    this.onResendTap,
    this.onTimerEnd,
    this.autoStartTimer = true,
  }) {
    _textController = OtpTextController(this);
    if (autoStartTimer) startTimer();
  }

  final int otpLength;
  final int timerDuration;
  final ValueChanged<String>? onCompleted;
  final VoidCallback? onResendTap;
  final VoidCallback? onTimerEnd;
  final bool autoStartTimer;

  late final OtpTextController _textController;
  Timer? _timer;
  int _remainingSeconds = 0;
  OtpState _state = OtpState.idle;
  String? _errorMessage;
  bool _isLoading = false;

  OtpTextController get textController => _textController;

  String get otp => _textController.text;

  int get remainingSeconds => _remainingSeconds;

  OtpState get state => _state;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  bool get isValid => otp.length == otpLength;

  bool get canResend => _state == OtpState.expired || _state == OtpState.idle;

  void startTimer() {
    _timer?.cancel();
    _remainingSeconds = timerDuration;
    _state = OtpState.countdown;
    _errorMessage = null;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _state = OtpState.expired;
        onTimerEnd?.call();
        notifyListeners();
      }
    });
  }

  void resend() {
    if (!canResend) return;
    clear();
    startTimer();
    onResendTap?.call();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _textController.clear();
    _errorMessage = null;
    notifyListeners();
  }

  void _onOtpChanged(String value) {
    if (_errorMessage != null) clearError();
    if (value.length == otpLength) {
      onCompleted?.call(value);
    }
  }

  String formatTime() {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }
}

class OtpTextController extends TextEditingController {
  OtpTextController(this._controller);

  final OtpController _controller;

  @override
  set text(String newText) {
    super.text = newText;
    _controller._onOtpChanged(newText);
  }

  @override
  void clear() {
    super.clear();
    _controller._onOtpChanged('');
  }
}
