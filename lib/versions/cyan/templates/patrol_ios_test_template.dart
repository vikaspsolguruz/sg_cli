part of '../cyan.dart';

String _patrolIOSTestTemplate() {
  return '''
@import XCTest;
@import patrol;
@import ObjectiveC.runtime;

PATROL_INTEGRATION_TEST_IOS_RUNNER(RunnerUITests)
''';
}
