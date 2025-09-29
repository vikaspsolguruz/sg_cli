import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newarch/core/constants/constants.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemActions {
  SystemActions._();

  static bool _isSharing = false;

  static void share({String? key, String? id, Duration debounceDuration = const Duration(seconds: 2)}) {
    if (_isSharing) return;
    _isSharing = true;
    Future.delayed(debounceDuration, () {
      _isSharing = false;
    });

    final params = <String, String>{};
    try {
      final encodedId = base64Url.encode(utf8.encode(id!));
      params['id'] = encodedId;
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
    }

    final uri = Uri.https(kAppLinkBaseUrl, '/share/$key', params.isNotEmpty ? params : null);
    SharePlus.instance.share(ShareParams(uri: uri));
  }

  static Future<bool> openMailApp() async {
    if (Platform.isIOS) {
      final uri = Uri.parse('message://');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
    } else if (Platform.isAndroid) {
      // Try to open Gmail via package intent (not URL)
      const packageName = 'com.google.android.gm';

      try {
        // Open Gmail app via package intent
        await launchUrl(
          Uri.parse('android-app://$packageName'),
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
