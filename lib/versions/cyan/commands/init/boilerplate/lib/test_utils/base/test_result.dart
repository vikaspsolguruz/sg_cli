/// Test result model for graceful exception handling
/// Designed for reusability and sg_cli code generation
class TestResult {
  final bool success;
  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  const TestResult({
    required this.success,
    required this.message,
    this.exception,
    this.stackTrace,
  });

  /// Create a successful test result
  factory TestResult.success([String message = 'Test passed']) {
    return TestResult(
      success: true,
      message: message,
    );
  }

  /// Create a failed test result with exception
  factory TestResult.failure(
    String message, {
    Exception? exception,
    StackTrace? stackTrace,
  }) {
    return TestResult(
      success: false,
      message: message,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// Create a failed test result from caught exception
  factory TestResult.fromException(
    Exception exception,
    StackTrace stackTrace, {
    String? customMessage,
  }) {
    return TestResult(
      success: false,
      message: customMessage ?? 'Test failed with exception: ${exception.toString()}',
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() {
    if (success) {
      return '✅ $message';
    } else {
      final buffer = StringBuffer('❌ $message');
      if (exception != null) {
        buffer.write('\n   Exception: $exception');
      }
      return buffer.toString();
    }
  }
}

/// Verification result for graceful UI element verification
class VerificationResult extends TestResult {
  final String? expectedValue;
  final String? actualValue;

  const VerificationResult({
    required super.success,
    required super.message,
    this.expectedValue,
    this.actualValue,
    super.exception,
    super.stackTrace,
  });

  /// Create a successful verification result
  factory VerificationResult.success(String message) {
    return VerificationResult(
      success: true,
      message: message,
    );
  }

  /// Create a failed verification result
  factory VerificationResult.failure(
    String message, {
    String? expected,
    String? actual,
    Exception? exception,
  }) {
    return VerificationResult(
      success: false,
      message: message,
      expectedValue: expected,
      actualValue: actual,
      exception: exception,
    );
  }
  
  /// Create a failed verification result from caught exception
  factory VerificationResult.fromException(
    Exception exception,
    StackTrace stackTrace, {
    String? customMessage,
  }) {
    return VerificationResult(
      success: false,
      message: customMessage ?? 'Verification failed with exception: ${exception.toString()}',
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() {
    if (success) {
      return '✅ $message';
    } else {
      final buffer = StringBuffer('❌ $message');
      if (expectedValue != null && actualValue != null) {
        buffer.write('\n   Expected: $expectedValue');
        buffer.write('\n   Actual: $actualValue');
      }
      if (exception != null) {
        buffer.write('\n   Exception: $exception');
      }
      return buffer.toString();
    }
  }
}
