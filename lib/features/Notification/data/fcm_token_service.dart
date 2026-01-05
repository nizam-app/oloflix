import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/constants/api_control/notification_api.dart';

class FcmTokenService {
  static final Logger _logger = Logger();

  /// Send FCM token to backend for storage
  static Future<bool> sendToken({
    required String fcmToken,
    required String authToken,
    String platform = 'android',
  }) async {
    try {
      _logger.i('📤 Sending FCM token to backend...');
      _logger.d('Token: ${fcmToken.substring(0, 20)}...');
      _logger.d('Platform: $platform');

      final response = await http.post(
        Uri.parse(NotificationApi.deviceToken),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'token': fcmToken,
          'platform': platform,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ FCM token sent successfully');
        _logger.d('Response: ${response.body}');
        return true;
      } else {
        _logger.e('❌ Failed to send FCM token');
        _logger.e('Status: ${response.statusCode}');
        _logger.e('Body: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Error sending FCM token: $e');
      _logger.e('Stack trace: $stackTrace');
      return false;
    }
  }

  static Future<void> pushTest() async {
    try {
      _logger.i('🧪 Testing push notification...');
      final res = await http.get(
        Uri.parse(NotificationApi.pushTest),
        headers: {'Accept': 'application/json'},
      );
      _logger.i('✅ push/test status: ${res.statusCode}');
      _logger.i('✅ push/test body: ${res.body}');
    } catch (e) {
      _logger.e('❌ push/test error: $e');
    }
  }

  static Future<void> pushUser({required String authToken}) async {
    try {
      _logger.i('📨 Sending push to user...');
      final res = await http.get(
        Uri.parse(NotificationApi.pushUser),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      _logger.i('✅ push/user status: ${res.statusCode}');
      _logger.i('✅ push/user body: ${res.body}');
    } catch (e) {
      _logger.e('❌ push/user error: $e');
    }
  }
}
