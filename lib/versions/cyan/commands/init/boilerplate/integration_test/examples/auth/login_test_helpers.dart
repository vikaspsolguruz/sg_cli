/// EXAMPLE: Login Test Helpers
///
/// This is an example of how to create feature-specific test helpers
/// using the generic test utilities from lib/test_utils/
///
/// When creating your own test helpers:
/// 1. Import generic utilities from package:your_app/test_utils/
/// 2. Define feature-specific test data as constants
/// 3. Create reusable helper methods for your feature
/// 4. Use BasePatrolTest.runTest() for consistent test patterns

import 'package:flutter_test/flutter_test.dart';
import 'package:newarch/core/constants/widget_keys.dart';
import 'package:newarch/core/utils/test_utils/base/base_patrol_test.dart';
import 'package:newarch/core/utils/test_utils/base/test_logger.dart';
import 'package:newarch/core/utils/test_utils/base/test_result.dart';
import 'package:patrol/patrol.dart';

/// Example: Feature-specific test constants
/// In your project, define these in your test helper files
class LoginTestData {
  // Private constructor
  LoginTestData._();

  // Valid test credentials
  static const validEmail = 'test@example.com';
  static const validPassword = 'password123';

  // Invalid test credentials
  static const invalidEmail = 'invalid-email';
  static const shortPassword = '123';

  // Expected UI text
  static const welcomeText = 'Welcome Back';
  static const subtitleText = 'Sign in to your account';
  static const loginSuccessText = 'Login successful!';

  // Expected error messages
  static const invalidEmailError = 'Invalid email format';
  static const shortPasswordError = 'Password too short';
}

/// Specialized helper class for login screen testing operations
/// Designed for reusability and sg_cli code generation
class LoginTestHelpers {
  // Private constructor to prevent instantiation
  LoginTestHelpers._();

  /// Verify all login screen elements are present and visible
  static void verifyLoginScreenElements() {
    // Verify input fields
    BasePatrolTest.verifyElementExists(
      find.byKey(Keys.loginEmailFieldKey),
      description: 'Email input field should be present',
    );

    BasePatrolTest.verifyElementExists(
      find.byKey(Keys.loginPasswordFieldKey),
      description: 'Password input field should be present',
    );

    BasePatrolTest.verifyElementExists(
      find.byKey(Keys.loginButtonKey),
      description: 'Login button should be present',
    );

    // Verify text labels
    BasePatrolTest.verifyTextExists(
      LoginTestData.welcomeText,
      description: 'Welcome text should be displayed',
    );

    BasePatrolTest.verifyTextExists(
      LoginTestData.subtitleText,
      description: 'Subtitle text should be displayed',
    );
  }

  /// Perform login with given credentials
  static Future<void> performLogin(
    PatrolIntegrationTester $,
    String email,
    String password,
  ) async {
    // Enter email
    await $(Keys.loginEmailFieldKey).enterText(email);

    // Enter password
    await $(Keys.loginPasswordFieldKey).enterText(password);

    // Tap login button
    await $(Keys.loginButtonKey).tap();
  }

  /// Perform login with valid test credentials
  static Future<void> performValidLogin(PatrolIntegrationTester $) async {
    await performLogin($, LoginTestData.validEmail, LoginTestData.validPassword);
  }

  /// Perform login with invalid email
  static Future<void> performInvalidEmailLogin(PatrolIntegrationTester $) async {
    await performLogin($, LoginTestData.invalidEmail, LoginTestData.validPassword);
  }

  /// Perform login with short password
  static Future<void> performShortPasswordLogin(PatrolIntegrationTester $) async {
    await performLogin($, LoginTestData.validEmail, LoginTestData.shortPassword);
  }

  /// Perform login with wrong credentials
  static Future<void> performWrongCredentialsLogin(PatrolIntegrationTester $) async {
    await performLogin($, 'wrong@example.com', 'wrongpassword');
  }

  /// Wait for login processing and verify success
  static Future<void> waitAndVerifyLoginSuccess(PatrolIntegrationTester $) async {
    // Wait for login processing (mock API delay)
    await BasePatrolTest.waitForProcessing($);

    // Verify success message appears
    BasePatrolTest.verifyTextExists(
      LoginTestData.loginSuccessText,
      description: 'Login success message should be displayed',
    );
  }

  /// Wait for login processing and verify error message
  static Future<void> waitAndVerifyLoginError(
    PatrolIntegrationTester $,
    String expectedErrorMessage,
  ) async {
    // Wait for login processing
    await BasePatrolTest.waitForProcessing($);

    // Verify error message appears
    BasePatrolTest.verifyTextExists(
      expectedErrorMessage,
      description: 'Error message "$expectedErrorMessage" should be displayed',
    );
  }

  /// Gracefully wait for login processing and verify error message
  /// Returns VerificationResult instead of throwing exception
  static Future<VerificationResult> waitAndVerifyLoginErrorGracefully(
    PatrolIntegrationTester $,
    String expectedErrorMessage,
  ) async {
    try {
      await BasePatrolTest.waitForProcessing($);

      final result = BasePatrolTest.verifyTextExistsGracefully(
        expectedErrorMessage,
        description: 'Error message "$expectedErrorMessage" should be displayed',
      );

      TestLogger.logResult(result);
      return result;
    } catch (e, stackTrace) {
      TestLogger.error(
        'Failed to verify login error',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
      return VerificationResult.fromException(
        e is Exception ? e : Exception(e.toString()),
        stackTrace,
        customMessage: 'Login error verification failed',
      );
    }
  }

  /// Gracefully verify login screen elements
  /// Returns list of VerificationResults for all elements
  static List<VerificationResult> verifyLoginScreenElementsGracefully() {
    final results = BasePatrolTest.verifyMultipleElements({
      'Email input field': find.byKey(Keys.loginEmailFieldKey),
      'Password input field': find.byKey(Keys.loginPasswordFieldKey),
      'Login button': find.byKey(Keys.loginButtonKey),
    });

    // Verify text labels
    results.add(
      BasePatrolTest.verifyTextExistsGracefully(
        LoginTestData.welcomeText,
        description: 'Welcome text',
      ),
    );

    results.add(
      BasePatrolTest.verifyTextExistsGracefully(
        LoginTestData.subtitleText,
        description: 'Subtitle text',
      ),
    );

    // Only log failures
    for (final result in results) {
      TestLogger.logResult(result);
    }

    return results;
  }

  /// Complete test for login screen display verification
  static void testLoginScreenDisplay() {
    BasePatrolTest.runTest('Login screen displays all elements', ($) async {
      verifyLoginScreenElements();
    });
  }

  /// Complete test for valid login flow
  static void testValidLogin() {
    BasePatrolTest.runTest('Login with valid credentials succeeds', ($) async {
      await performValidLogin($);
      await waitAndVerifyLoginSuccess($);
    });
  }

  /// Complete test for invalid email login
  static void testInvalidEmailLogin() {
    BasePatrolTest.runTest('Login with invalid email shows error', ($) async {
      await performInvalidEmailLogin($);
      await waitAndVerifyLoginError($, LoginTestData.invalidEmailError);
    });
  }

  /// Complete test for short password login
  static void testShortPasswordLogin() {
    BasePatrolTest.runTest('Login with short password shows error', ($) async {
      await performShortPasswordLogin($);
      await waitAndVerifyLoginError($, LoginTestData.shortPasswordError);
    });
  }

  /// Complete test for invalid email login with graceful error handling
  static void testInvalidEmailLoginGracefully() {
    BasePatrolTest.runTest('Login with invalid email (graceful)', ($) async {
      await performInvalidEmailLogin($);
      await waitAndVerifyLoginErrorGracefully(
        $,
        LoginTestData.invalidEmailError,
      );
      // Silent on success, only logs on failure
    });
  }

  /// Complete test for short password login with graceful error handling
  static void testShortPasswordLoginGracefully() {
    BasePatrolTest.runTest('Login with short password (graceful)', ($) async {
      await performShortPasswordLogin($);
      await waitAndVerifyLoginErrorGracefully(
        $,
        LoginTestData.shortPasswordError,
      );
      // Silent on success, only logs on failure
    });
  }
}
