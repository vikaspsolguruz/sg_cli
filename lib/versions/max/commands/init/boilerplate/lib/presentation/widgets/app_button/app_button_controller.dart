import 'package:flutter/material.dart';

class AppButtonController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisabled = false;

  bool get isLoading => _isLoading;

  bool get isDisabled => _isDisabled;

  void startLoading() {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    if (!_isLoading) return;
    _isLoading = false;
    notifyListeners();
  }

  void disable() {
    if (_isDisabled) return;
    _isDisabled = true;
    notifyListeners();
  }

  void enable() {
    if (!_isDisabled) return;
    _isDisabled = false;
    notifyListeners();
  }
}
