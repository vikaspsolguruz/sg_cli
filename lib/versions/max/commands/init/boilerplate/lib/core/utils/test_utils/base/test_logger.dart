import 'package:max_arch/core/utils/test_utils/base/test_result.dart';

/// Test logger utility for minimal, critical-only logging
/// Only logs success and errors - no verbose progress/status messages
class TestLogger {
  // Private constructor to prevent instantiation
  TestLogger._();

  /// Log a test result (only if failed)
  static void logResult(TestResult result) {
    if (!result.success) {
      print(result.toString());
    }
  }

  /// Log error message with exception/stacktrace
  static void error(String message, {Exception? exception, StackTrace? stackTrace}) {
    print('❌ ERROR: $message');
    if (exception != null) {
      print('   Exception: $exception');
    }
    if (stackTrace != null) {
      print('   StackTrace: ${stackTrace.toString().split('\n').take(5).join('\n   ')}');
    }
  }

  /// Log success message
  static void success(String message) {
    print('✅ $message');
  }
}
