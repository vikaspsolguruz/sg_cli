/// EXAMPLE: Login Integration Tests
///
/// This demonstrates how to use the generic test utilities from lib/test_utils/
/// to create integration tests for your features.
///
/// Key patterns shown:
/// - Using BasePatrolTest.runTest() for consistent test structure
/// - Creating feature-specific helper classes (LoginTestHelpers)
/// - Graceful exception handling with TestResult/VerificationResult
/// - Minimal logging with TestLogger

import 'login_test_helpers.dart';

/// Login screen integration tests using reusable helper classes
/// Designed for consistency and sg_cli code generation
/// Now with graceful exception handling!
void main() {
  // Test login screen element display using helper methods
  LoginTestHelpers.testLoginScreenDisplay();

  // Test valid login flow using helper methods
  LoginTestHelpers.testValidLogin();

  // Test invalid email scenario with GRACEFUL error handling
  // No hard exceptions - logs warnings instead
  LoginTestHelpers.testInvalidEmailLoginGracefully();

  // Test short password scenario with GRACEFUL error handling
  // No hard exceptions - logs warnings instead
  LoginTestHelpers.testShortPasswordLoginGracefully();
}
