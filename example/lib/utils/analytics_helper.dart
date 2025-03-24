import 'package:flutter/widgets.dart';

class AnalyticsHelper {
  static AnalyticsHelper? _instance = AnalyticsHelper._internal();

  factory AnalyticsHelper() {
    return _instance ??= AnalyticsHelper._internal();
  }

  AnalyticsHelper._internal();

  void init(BuildContext context) {}

  void dispose() {
    _instance = null;
  }

  void logCustomEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) {
    debugPrint('logCustomEvent: $eventName, parameters: $parameters');
  }

  void setTestingInstance(AnalyticsHelper newInstance) {
    _instance = newInstance;
  }
}
