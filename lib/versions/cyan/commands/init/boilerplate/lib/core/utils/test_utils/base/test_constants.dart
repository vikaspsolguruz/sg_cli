/// Generic test constants for timing and delays
/// Designed for reusability across all Flutter projects with Patrol
/// Project-specific test data should be defined in your test files
class TestConstants {
  // Private constructor to prevent instantiation
  TestConstants._();

  // ==================== Generic Timing Constants ====================

  /// Standard delay for waiting after UI interactions (e.g., button taps)
  static const shortDelayDuration = Duration(milliseconds: 500);

  /// Medium delay for animations and transitions
  static const mediumDelayDuration = Duration(seconds: 1);

  /// Standard delay for waiting for processing/loading states
  static const testWaitDuration = Duration(seconds: 2);

  /// Timeout for API calls and network requests
  static const networkTimeoutDuration = Duration(seconds: 30);

  /// Delay between retry attempts
  static const retryDelayDuration = Duration(seconds: 5);

  /// Maximum time to wait for an element to appear
  static const elementTimeoutDuration = Duration(seconds: 10);

  /// Delay for pump and settle operations
  static const pumpSettleDuration = Duration(milliseconds: 100);

  /// Long timeout for complex operations (e.g., file uploads)
  static const longTimeoutDuration = Duration(minutes: 2);
}
