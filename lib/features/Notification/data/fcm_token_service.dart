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
      final endpoint = NotificationApi.deviceToken;
      _logger.i('📤 Sending FCM token to backend...');
      _logger.i('📍 Endpoint: $endpoint');
      _logger.d('Token (first 20 chars): ${fcmToken.substring(0, fcmToken.length > 20 ? 20 : fcmToken.length)}...');
      _logger.d('Token length: ${fcmToken.length} characters');
      _logger.d('Platform: $platform');
      _logger.d('Auth token (first 20 chars): ${authToken.substring(0, authToken.length > 20 ? 20 : authToken.length)}...');

      if (fcmToken.isEmpty) {
        _logger.e('❌ FCM token is empty, cannot send');
        return false;
      }

      if (authToken.isEmpty) {
        _logger.e('❌ Auth token is empty, cannot send FCM token');
        return false;
      }

      final requestBody = {
        'token': fcmToken,
        'platform': platform,
      };

      _logger.d('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _logger.e('❌ Request timeout after 30 seconds');
          throw Exception('Request timeout');
        },
      );

      _logger.i('📥 Response received');
      _logger.d('Status code: ${response.statusCode}');
      _logger.d('Response headers: ${response.headers}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ FCM token sent successfully to backend');
        return true;
      } else {
        _logger.e('❌ Failed to send FCM token');
        _logger.e('Status: ${response.statusCode}');
        _logger.e('Body: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Error sending FCM token: $e');
      _logger.e('Error type: ${e.runtimeType}');
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
