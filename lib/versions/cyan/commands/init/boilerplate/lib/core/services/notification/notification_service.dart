import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newarch/core/utils/console_print.dart';

/// Handles Firebase messages received in the background.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  xResponsePrint(message.data, title: ' Background Message Received');
  await Firebase.initializeApp();
}

class NotificationService {
  RemoteMessage? initialMessage;

  static final NotificationService instance = NotificationService._();

  NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static String fcmToken = '';

  /// Initializes notification service.
  Future<void> initialize() async {
    await _createNotificationChannel();
    await _requestUserPermissions();
    await _initializeLocalNotificationSettings();
    _setupFirebaseMessageListeners();
    await _retrieveFcmToken();
    await checkInitialNotification();
  }

  /// Checks Initial notification if app was opened via a notification tap.
  Future<void> checkInitialNotification() async {
    // if (currentUser == null) return;
    try {
      initialMessage = await _messaging.getInitialMessage();
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
    }
  }

  /// Handles notification if app was opened via a notification tap.
  void handleInitialNotification() {
    // if (currentUser == null || initialMessage == null) return;
    _processNotificationData(initialMessage!.data);
  }

  /// Creates notification channel (Android).
  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      enableLights: true,
      showBadge: false,
    );

    if (Platform.isAndroid) {
      final androidPlugin = localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(channel);
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  /// Requests notification permissions (iOS & Firebase).
  Future<void> _requestUserPermissions() async {
    if (Platform.isIOS) {
      await localNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        sound: true,
      );
    }

    await _messaging.requestPermission(badge: false);
  }

  // Initializes local notification settings.
  Future<void> _initializeLocalNotificationSettings() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(defaultPresentBadge: false);
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
  }

  // Sets up Firebase Messaging listeners.
  void _setupFirebaseMessageListeners() {
    // Background messages handled here.
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);

    // Foreground messages trigger local notification.
    FirebaseMessaging.onMessage.listen(_displayForegroundNotification);

    // Handles when user taps on a notification.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      xPrint(message.data, title: 'Notification Opened App');
      _processNotificationData(message.data);
    });

    _messaging.onTokenRefresh.listen((newToken) {
      xPrint(newToken, title: 'FCM Token refreshed');
      fcmToken = newToken;
    });
  }

  // Retrieves and caches the current FCM token.
  Future<void> _retrieveFcmToken() async {
    try {
      fcmToken = await _messaging.getToken() ?? '';
      xPrint(fcmToken, title: 'FCM token');
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
    }
  }

  // Shows local notification for messages received while app is foreground.
  void _displayForegroundNotification(RemoteMessage message) {
    xResponsePrint(message.data, title: 'Foreground Message:');

    final notification = message.notification;
    if (notification == null) {
      return;
    }

    final String? title = notification.title;
    final String? body = notification.body;
    final int notificationId = notification.hashCode;

    // Common NotificationDetails for Android and iOS
    NotificationDetails platformChannelSpecifics;

    if (notification.android != null) {
      platformChannelSpecifics = const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          icon: 'ic_launcher',
        ),
      );
    } else if (notification.apple != null) {
      platformChannelSpecifics = const NotificationDetails(
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
    } else {
      xErrorPrint('⚠️ No platform-specific notification details found.');
      return;
    }

    localNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Handles user tapping on local notification while the App is in Foreground.
  void _handleNotificationResponse(NotificationResponse response) {
    // if (currentUser == null) return;
    final payload = response.payload;
    if (payload != null) {
      xResponsePrint(payload, title: 'Notification tapped with payload');
    }
    // Go.toNamed(Routes.notification);
  }

  // Processes notification data for app navigation or other logic.
  void _processNotificationData(Map<String, dynamic> data) {
    xResponsePrint(data, title: 'Notification Payload');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Go.toNamed(Routes.notification);
    });
  }
}
