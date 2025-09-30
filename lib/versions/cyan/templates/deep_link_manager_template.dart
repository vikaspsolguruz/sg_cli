part of '../cyan.dart';

String deepLinkManagerTemplate(String projectName) {
  return '''import 'dart:async';

import 'package:app_links/app_links.dart';

final _appLinks = AppLinks();
StreamSubscription<Uri>? _linkSubscription;

class DeepLinkManager {
  DeepLinkManager._();

  static final instance = DeepLinkManager._();

  /// Initialize deep link handling
  Future<void> initialize() async {
    // Handle the "cold start" link (app opened via deep link):
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    // Listen for any links while app is running/in background:
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (err) {
        print('Deep link error: \$err');
      },
    );
  }

  /// Handle incoming deep links
  void _handleDeepLink(Uri uri) {
    print('Deep link received: \$uri');
    
    // TODO: Add your custom deep link handling logic here
    // Example:
    // final segments = uri.pathSegments;
    // if (segments.isNotEmpty) {
    //   final route = segments[0];
    //   // Navigate to specific screen based on route
    // }
    
    // Access query parameters:
    // final params = uri.queryParameters;
    // final userId = params['user_id'];
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
  }
}
''';
}
