// ✅ NATIVE NOTIFICATION SERVICE
// Uses CustomFirebaseMessagingService (Kotlin) for all notification display
// No AwesomeNotifications dependency

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:max_arch/core/constants/method_channels.dart';
import 'package:max_arch/core/data/current_user.dart';
import 'package:max_arch/core/local_storage/local_storage.dart';
import 'package:max_arch/core/repositories/miscellaneous_repository.dart';
import 'package:max_arch/core/utils/console_print.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
class NativeNotificationService {
  static final NativeNotificationService instance = NativeNotificationService._();

  NativeNotificationService._();

  static const MethodChannel _fcmChannel = MethodChannel(MethodChannels.fcm);
  static String fcmToken = '';

  /// Initializes notification service
  Future<void> initialize() async {
    await _requestNotificationPermission();
    await _retrieveFcmToken();
    _setupNativeNotificationTapListener();
    await _storeAuthTokenForNative();
  }

  Future<void> _requestNotificationPermission() async {
    try {
      final status = await Permission.notification.status;

      if (status.isDenied) {
        final result = await Permission.notification.request();

        if (result.isGranted) {
        } else if (result.isPermanentlyDenied) {
        } else {}
      } else if (status.isGranted) {
      } else if (status.isPermanentlyDenied) {}
    } catch (e, s) {
      xErrorPrint('Error requesting notification permission: $e', stackTrace: s);
    }
  }

  Future<void> _storeAuthTokenForNative() async {
    try {
      final token = currentUser?.token;
      if (token != null) {
        await LocalStorage.setAuthToken('auth_token', token);
      }
    } catch (e) {
      xErrorPrint('Error storing auth token for native: $e');
    }
  }

  void _setupNativeNotificationTapListener() {
    const platform = MethodChannel(MethodChannels.notificationTap);
    platform.setMethodCallHandler((call) async {
      if (call.method == MethodCalls.notificationTap) {
        final raw = call.arguments as Map<dynamic, dynamic>?;
        if (raw == null) return;

        // Normalize dynamic map to <String, dynamic>
        final Map<String, dynamic> args = raw.map((key, value) => MapEntry(key.toString(), value));
        _handleNotificationTap(args);
      } else if (call.method == 'onFCMTokenRefresh') {
        final args = call.arguments as Map<dynamic, dynamic>?;
        final token = args?['token'] as String?;
        if (token != null && token.isNotEmpty) {
          _handleFCMTokenRefresh(token);
        }
      }
    });
  }

  void _handleNotificationTap(Map<String, dynamic> args) {
    // TODO: Preprocess args
    WidgetsBinding.instance.scheduleFrame();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // TODO: Handle chat notification navigations
      },
    );
  }

  void _handleFCMTokenRefresh(String token) {
    xPrint(token, title: 'FCM Token Refresh');

    fcmToken = token;

    if (LocalStorage.getFcmToken() != token) {
      LocalStorage.setFcmToken(token);

      if (currentUser != null) {
        MiscellaneousRepository.updateFcmToken();
      }
    }
  }

  Future<void> _retrieveFcmToken() async {
    try {
      final String? token = await _fcmChannel.invokeMethod<String>(MethodCalls.getFcmToken);
      fcmToken = token?.nullable ?? LocalStorage.getFcmToken() ?? '';

      if (fcmToken.isNotEmpty && LocalStorage.getFcmToken() != fcmToken) {
        LocalStorage.setFcmToken(fcmToken);
        if (currentUser != null) {
          MiscellaneousRepository.updateFcmToken();
        }
      }

      xPrint('FCM Token retrieved: ${fcmToken.substring(0, 20)}...', title: 'FCM Token');
    } catch (e, s) {
      xErrorPrint('Error getting FCM token from native: $e', stackTrace: s);
    }
  }

  /// Clears all notifications for a specific conversation
  Future<void> cancelNotificationsByGroupKey(String groupKey) async {
    if (groupKey.isEmpty) return;
    try {
      const platform = MethodChannel('com.mifootball/messaging_notifications');
      await platform.invokeMethod('clearConversation', {'conversationId': groupKey});
    } catch (e) {
      xErrorPrint('Failed to cancel notifications for group: $groupKey, error: $e');
    }
  }

  /// Cancels all notifications
  Future<void> cancelAllNotifications() async {
    try {
      const platform = MethodChannel('com.mifootball/messaging_notifications');
      await platform.invokeMethod('clearAll');
    } catch (e) {
      xErrorPrint('Failed to cancel all notifications: $e');
    }
  }

  /// Cancels a specific notification by ID
  Future<void> cancelNotification(int id) async {
    try {
      const platform = MethodChannel('com.mifootball/messaging_notifications');
      await platform.invokeMethod('cancel', {'notificationId': id});
    } catch (e) {
      xErrorPrint('Failed to cancel notification $id: $e');
    }
  }
}
