import 'package:max_arch/core/utils/console_print.dart';

class AnalyticsHelper {
  AnalyticsHelper._internal();

  static void logCustomEvent(
    String eventName, {
    required Map<String, dynamic> parameters,
    String? blocName,
  }) {
    if (parameters.isEmpty) {
      xPrint('No parameters', title: '$blocName > $eventName');
    } else {
      xJsonPrint(parameters, title: '$blocName > $eventName');
    }
  }
}
