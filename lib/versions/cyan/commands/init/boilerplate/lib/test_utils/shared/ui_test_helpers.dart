import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:newarch/presentation/widgets/loader.dart';

/// Shared UI testing utilities for common interactions across all features
/// Designed for reusability and sg_cli code generation
class UITestHelpers {
  // Private constructor to prevent instantiation
  UITestHelpers._();

  /// Common navigation helper - can be used across features
  static Future<void> navigateBack(PatrolIntegrationTester $) async {
    await $(find.byTooltip('Back')).tap();
  }

  /// Common loading verification - reusable across screens
  static void verifyLoadingIndicator() {
    expect(find.byType(CommonLoader), findsOneWidget);
  }

  /// Common error dialog verification - reusable pattern
  static void verifyErrorDialog(String expectedErrorMessage) {
    expect(find.text(expectedErrorMessage), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
  }

  /// Common success snackbar verification - reusable pattern
  static void verifySuccessSnackbar(String expectedMessage) {
    expect(find.text(expectedMessage), findsOneWidget);
  }

  /// Common form field verification - reusable across forms
  static void verifyFormField(String key, {bool shouldExist = true}) {
    final finder = find.byKey(Key(key));
    expect(finder, shouldExist ? findsOneWidget : findsNothing);
  }

  /// Common button verification - reusable across screens
  static void verifyButton(String key, {bool shouldBeEnabled = true}) {
    final finder = find.byKey(Key(key));
    expect(finder, findsOneWidget);
    // Additional button state verification can be added here
  }
}
