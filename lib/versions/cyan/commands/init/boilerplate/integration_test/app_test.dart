import 'package:flutter_test/flutter_test.dart';

import 'examples/auth/login_test.dart' as login;

/// Main test orchestrator that groups all integration tests
void main() {
  // Example
  group('Login Tests', login.main);
}
