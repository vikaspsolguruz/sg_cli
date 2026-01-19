import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Handles native Android messaging-style notifications
/// Shows multiple messages with avatars in a single conversation
class MessagingNotificationHandler {
  static const MethodChannel _channel = MethodChannel('com.mifootball/messaging_notifications');

  /// Shows a chat message in a conversation-style notification (Android only)
  /// On iOS, this falls back to regular notifications
  static Future<bool> showChatMessage({
    required String conversationId,
    required String conversationTitle,
    required String senderName,
    required String senderId,
    required String message,
    required String senderAvatarUrl,
    required int timestamp,
    required Map<String, String> payload,
    bool isFromCurrentUser = false,
  }) async {
    if (!defaultTargetPlatform.toString().contains('android')) {
      return false; // Not supported on this platform
    }

    try {
      final result = await _channel.invokeMethod('showChatMessage', {
        'conversationId': conversationId,
        'conversationTitle': conversationTitle,
        'senderName': senderName,
        'senderId': senderId,
        'message': message,
        'senderAvatarUrl': senderAvatarUrl,
        'timestamp': timestamp,
        'payload': payload,
        'isFromCurrentUser': isFromCurrentUser,
      });
      return result == true;
    } catch (e) {
      debugPrint('Error showing messaging notification: $e');
      return false;
    }
  }

  /// Clears all messages for a conversation
  static Future<void> clearConversation(String conversationId) async {
    if (!defaultTargetPlatform.toString().contains('android')) return;

    try {
      await _channel.invokeMethod('clearConversation', {
        'conversationId': conversationId,
      });
    } catch (e) {
      debugPrint('Error clearing conversation: $e');
    }
  }

  /// Clears all messaging notifications
  static Future<void> clearAll() async {
    if (!defaultTargetPlatform.toString().contains('android')) return;

    try {
      await _channel.invokeMethod('clearAll');
    } catch (e) {
      debugPrint('Error clearing all notifications: $e');
    }
  }
}
