import 'package:flutter_test/flutter_test.dart';
import 'package:newarch/_app_initializer.dart';
import 'package:newarch/app/app_provider.dart';
import 'package:newarch/core/utils/test_utils/base/test_logger.dart';
import 'package:newarch/core/utils/test_utils/base/test_result.dart';
import 'package:patrol/patrol.dart';

/// Base class for Patrol integration tests providing common setup and utilities
/// Designed for reusability and sg_cli code generation
abstract class BasePatrolTest {
  /// Standard frame policy for consistent test behavior
  static const framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  /// Common app initialization and launch sequence
  /// This method should be called at the start of every patrol test
  static Future<void> initializeAndLaunchApp(PatrolIntegrationTester $) async {
    // Initialize app dependencies (required by main.dart)
    await initializeApp();

    // Launch the app with proper settling
    await $.pumpWidgetAndSettle(const AppProvider());
  }

  /// Wait for processing with standard delay (useful for API calls)
  static Future<void> waitForProcessing(
    PatrolIntegrationTester $, {
    Duration delay = const Duration(seconds: 3),
  }) async {
    await $.pump(delay);
  }

  /// Standard test wrapper that handles common setup
  /// Usage: BasePatrolTest.runTest('Test description', (tester) async { ... })
  static void runTest(
    String description,
    Future<void> Function(PatrolIntegrationTester) testBody,
  ) {
    patrolTest(
      description,
      framePolicy: framePolicy,
      ($) async {
        await initializeAndLaunchApp($);
        await testBody($);
      },
    );
  }

  /// Utility method for common element verification
  static void verifyElementExists(Finder finder, {String? description}) {
    expect(
      finder,
      findsOneWidget,
      reason: description ?? 'Expected element should be present',
    );
  }

  /// Utility method for text verification
  static void verifyTextExists(String text, {String? description}) {
    expect(
      find.text(text),
      findsOneWidget,
      reason: description ?? 'Expected text "$text" should be present',
    );
  }

  // ==================== Graceful Verification Methods ====================

  /// Gracefully verify element exists without throwing exception
  /// Returns VerificationResult for structured error handling
  static VerificationResult verifyElementExistsGracefully(
    Finder finder, {
    String? description,
  }) {
    try {
      final result = finder.evaluate();
      if (result.length == 1) {
        return VerificationResult.success(
          description ?? 'Element found successfully',
        );
      } else {
        return VerificationResult.failure(
          description ?? 'Element not found',
          expected: '1 widget',
          actual: '${result.length} widgets',
        );
      }
    } catch (e, stackTrace) {
      TestLogger.error(
        'Exception while verifying element: ${description ?? ""}',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
      return VerificationResult.failure(
        description ?? 'Element verification failed with exception',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Gracefully verify text exists without throwing exception
  /// Returns VerificationResult for structured error handling
  static VerificationResult verifyTextExistsGracefully(
    String text, {
    String? description,
  }) {
    try {
      final finder = find.text(text);
      final result = finder.evaluate();

      if (result.isNotEmpty) {
        return VerificationResult.success(
          description ?? 'Text "$text" found successfully',
        );
      } else {
        return VerificationResult.failure(
          description ?? 'Text "$text" not found',
          expected: 'Text widget with "$text"',
          actual: 'No matching text widgets',
        );
      }
    } catch (e, stackTrace) {
      TestLogger.error(
        'Exception while verifying text: ${description ?? text}',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
      return VerificationResult.failure(
        description ?? 'Text verification failed with exception',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Gracefully verify multiple elements
  /// Returns list of VerificationResults for batch verification
  static List<VerificationResult> verifyMultipleElements(
    Map<String, Finder> elements,
  ) {
    final results = <VerificationResult>[];

    for (final entry in elements.entries) {
      final result = verifyElementExistsGracefully(
        entry.value,
        description: entry.key,
      );
      results.add(result);
    }

    return results;
  }

  /// Check if any verification failed
  static bool hasFailures(List<VerificationResult> results) {
    return results.any((result) => !result.success);
  }

  /// Get failure count from results
  static int getFailureCount(List<VerificationResult> results) {
    return results.where((result) => !result.success).length;
  }
}
