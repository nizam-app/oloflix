import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/fcm_token_service.dart';

class PushNotificationManager {
  static final Logger _logger = Logger();
  static bool _isInitialized = false;

  /// Initialize push notifications and send token to backend
  static Future<void> init({
    required String authToken,
    String? platform,
  }) async {
    if (_isInitialized) {
      _logger.w('⚠️ PushNotificationManager already initialized');
      return;
    }

    try {
      _logger.i('🚀 Initializing PushNotificationManager...');

      // Auto-detect platform if not provided
      final devicePlatform = platform ?? _getPlatform();

      final fm = FirebaseMessaging.instance;

      // Request permissions
      final settings = await fm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      _logger.i('🔔 Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _logger.w('⚠️ Notification permission denied by user');
        return;
      }

      // Get FCM token
      final String? token = await fm.getToken();

      if (token == null || token.isEmpty) {
        _logger.e('❌ FCM token is null or empty');
        return;
      }

      _logger.i('🔥 FCM Token obtained: ${token.substring(0, 20)}...');

      // Send token to backend
      final success = await FcmTokenService.sendToken(
        fcmToken: token,
        authToken: authToken,
        platform: devicePlatform,
      );

      if (success) {
        // Save token locally for reference
        await _saveTokenLocally(token);
        _logger.i('✅ Token sent to backend successfully');
      } else {
        _logger.e('❌ Failed to send token to backend');
      }

      // Listen for token refresh
      _setupTokenRefreshListener(authToken, devicePlatform);

      _isInitialized = true;
      _logger.i('✅ PushNotificationManager initialized successfully');
    } catch (e, stackTrace) {
      _logger.e('❌ Error initializing PushNotificationManager: $e');
      _logger.e('Stack trace: $stackTrace');
    }
  }

  /// Setup listener for token refresh
  static void _setupTokenRefreshListener(String authToken, String platform) {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      _logger.i('♻️ FCM Token refreshed: ${newToken.substring(0, 20)}...');

      if (newToken.isEmpty) {
        _logger.w('⚠️ New token is empty');
        return;
      }

      // Send new token to backend
      final success = await FcmTokenService.sendToken(
        fcmToken: newToken,
        authToken: authToken,
        platform: platform,
      );

      if (success) {
        await _saveTokenLocally(newToken);
        _logger.i('✅ New token sent to backend');
      } else {
        _logger.e('❌ Failed to send new token to backend');
      }
    }).onError((error) {
      _logger.e('❌ Error in token refresh listener: $error');
    });
  }

  /// Save FCM token locally
  static Future<void> _saveTokenLocally(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      await prefs.setString('fcm_token_timestamp', DateTime.now().toIso8601String());
      _logger.d('💾 Token saved locally');
    } catch (e) {
      _logger.e('❌ Error saving token locally: $e');
    }
  }

  /// Get saved FCM token
  static Future<String?> getSavedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('fcm_token');
    } catch (e) {
      _logger.e('❌ Error getting saved token: $e');
      return null;
    }
  }

  /// Get current platform
  static String _getPlatform() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isMacOS) {
      return 'macos';
    } else if (Platform.isLinux) {
      return 'linux';
    } else {
      return 'unknown';
    }
  }

  /// Reset initialization flag (for testing)
  static void reset() {
    _isInitialized = false;
    _logger.i('🔄 PushNotificationManager reset');
  }
}
