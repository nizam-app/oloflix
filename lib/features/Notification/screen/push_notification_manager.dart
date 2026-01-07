import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/fcm_token_service.dart';
import '../data/notification_service.dart';

class PushNotificationManager {
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  static String? _lastAuthToken;

  /// Initialize push notifications and send token to backend
  static Future<void> init({
    required String authToken,
    String? platform,
  }) async {
    // Allow re-initialization if auth token changed (e.g., new login)
    if (_isInitialized && _lastAuthToken == authToken) {
      _logger.w('⚠️ PushNotificationManager already initialized with same token');
      // Still try to send token if we have one, in case it wasn't sent before
      String? tokenToSend;
      
      // First try to get current token
      try {
        final fm = FirebaseMessaging.instance;
        if (Platform.isAndroid) {
          tokenToSend = await fm.getToken();
        } else {
          tokenToSend = await NotificationService.getFCMToken();
        }
      } catch (e) {
        _logger.w('⚠️ Could not get current token: $e');
      }
      
      // If no current token, try saved token
      if (tokenToSend == null || tokenToSend.isEmpty) {
        tokenToSend = await getSavedToken();
      }
      
      if (tokenToSend != null && tokenToSend.isNotEmpty) {
        _logger.i('🔄 Re-sending FCM token to backend...');
        final success = await FcmTokenService.sendToken(
          fcmToken: tokenToSend,
          authToken: authToken,
          platform: platform ?? _getPlatform(),
        );
        if (success) {
          _logger.i('✅ FCM token re-sent successfully');
          await _saveTokenLocally(tokenToSend);
        } else {
          _logger.e('❌ Failed to re-send FCM token');
        }
      } else {
        _logger.w('⚠️ No FCM token available to re-send');
      }
      return;
    }
    
    // Reset if auth token changed (new login)
    if (_isInitialized && _lastAuthToken != authToken) {
      _logger.i('🔄 New auth token detected, re-initializing...');
      _isInitialized = false;
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

      // Get FCM token safely (handles iOS APNS token delay)
      String? token;
      
      if (Platform.isIOS) {
        // On iOS, use NotificationService which handles APNS token properly
        _logger.i('📱 iOS detected, using safe token retrieval...');
        
        // Try multiple times with increasing delays for iOS
        int retryCount = 0;
        const maxRetries = 5;
        const retryDelays = [500, 1000, 1500, 2000, 3000]; // milliseconds
        
        while (token == null && retryCount < maxRetries) {
          if (retryCount > 0) {
            _logger.i('🔄 Retrying FCM token retrieval (attempt ${retryCount + 1}/$maxRetries)...');
            await Future.delayed(Duration(milliseconds: retryDelays[retryCount - 1]));
          }
          
          token = await NotificationService.getFCMToken();
          
          if (token != null) {
            _logger.i('✅ FCM token retrieved successfully on attempt ${retryCount + 1}');
            break;
          }
          
          retryCount++;
        }
        
        if (token == null) {
          _logger.w('⚠️ FCM token not available after $maxRetries attempts, checking for saved token...');
          
          // Try to get saved token as fallback
          final savedToken = await getSavedToken();
          if (savedToken != null && savedToken.isNotEmpty) {
            _logger.i('💾 Found saved FCM token for iOS, using it...');
            token = savedToken;
          } else {
            _logger.w('⚠️ No saved token found, will retry via refresh listener');
            // Setup token refresh listener - token will be sent when available
            _setupTokenRefreshListener(authToken, devicePlatform);
            _isInitialized = true;
            _lastAuthToken = authToken;
            _logger.i('✅ PushNotificationManager initialized, waiting for token refresh...');
            return;
          }
        }
      } else {
        // Android - direct token retrieval
        _logger.i('🤖 Android detected, retrieving FCM token...');
        try {
          token = await fm.getToken();
          if (token != null) {
            _logger.i('✅ Android FCM token retrieved: ${token.substring(0, 20)}...');
            _logger.d('Token length: ${token.length} characters');
          } else {
            _logger.w('⚠️ Android FCM token is null');
          }
        } catch (e) {
          _logger.e('❌ Error getting Android FCM token: $e');
          token = null;
        }
      }

      if (token == null || token.isEmpty) {
        _logger.e('❌ FCM token is null or empty after retrieval attempt');
        
        // Try to get saved token from main.dart or previous session
        final savedToken = await getSavedToken();
        if (savedToken != null && savedToken.isNotEmpty) {
          _logger.i('💾 Found saved FCM token, using it...');
          token = savedToken;
        } else {
          _logger.w('⚠️ No saved token found, will wait for token refresh');
          // Setup refresh listener as fallback
          _setupTokenRefreshListener(authToken, devicePlatform);
          _isInitialized = true;
          _lastAuthToken = authToken;
          _logger.w('⚠️ FCM token not available, will be sent when token refresh occurs');
          return;
        }
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
      _lastAuthToken = authToken;
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
      _logger.i('📱 Platform: $platform');

      if (newToken.isEmpty) {
        _logger.w('⚠️ New token is empty');
        return;
      }

      // Get fresh auth token from storage (in case it was updated)
      String currentAuthToken = authToken;
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedToken = prefs.getString('token');
        if (savedToken != null && savedToken.isNotEmpty) {
          currentAuthToken = savedToken;
          _logger.d('🔄 Using updated auth token from storage');
        }
      } catch (e) {
        _logger.w('⚠️ Could not get updated auth token, using provided token: $e');
      }

      // Ensure we have a valid auth token before sending
      if (currentAuthToken.isEmpty) {
        _logger.e('❌ Auth token is empty, cannot send FCM token');
        return;
      }

      // Send new token to backend
      _logger.i('📤 Sending refreshed token to backend...');
      final success = await FcmTokenService.sendToken(
        fcmToken: newToken,
        authToken: currentAuthToken,
        platform: platform,
      );

      if (success) {
        await _saveTokenLocally(newToken);
        _logger.i('✅ New token sent to backend successfully');
      } else {
        _logger.e('❌ Failed to send new token to backend');
        _logger.e('💡 Token will be retried on next app launch or login');
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

  /// Reset initialization flag (for testing or logout)
  static void reset() {
    _isInitialized = false;
    _lastAuthToken = null;
    _logger.i('🔄 PushNotificationManager reset');
  }

  /// Force re-send FCM token to backend (useful for debugging)
  static Future<bool> forceResendToken({
    required String authToken,
    String? platform,
  }) async {
    try {
      _logger.i('🔄 Force re-sending FCM token...');
      
      final devicePlatform = platform ?? _getPlatform();
      final fm = FirebaseMessaging.instance;
      
      // Get current token
      String? token;
      if (Platform.isIOS) {
        token = await NotificationService.getFCMToken();
      } else {
        try {
          token = await fm.getToken();
        } catch (e) {
          _logger.w('⚠️ Error getting current token: $e');
          token = null;
        }
      }
      
      // Fallback to saved token if current token is null
      if (token == null || token.isEmpty) {
        _logger.w('⚠️ Current FCM token is null or empty, trying saved token...');
        final savedToken = await getSavedToken();
        if (savedToken != null && savedToken.isNotEmpty) {
          _logger.i('💾 Using saved FCM token for force resend...');
          token = savedToken;
        } else {
          _logger.e('❌ Cannot force resend: FCM token is null or empty and no saved token found');
          return false;
        }
      }
      
      _logger.i('🔥 FCM Token obtained: ${token.substring(0, 20)}...');
      
      // Send token to backend
      final success = await FcmTokenService.sendToken(
        fcmToken: token,
        authToken: authToken,
        platform: devicePlatform,
      );
      
      if (success) {
        await _saveTokenLocally(token);
        _logger.i('✅ Token force re-sent successfully');
      } else {
        _logger.e('❌ Failed to force re-send token');
      }
      
      return success;
    } catch (e, stackTrace) {
      _logger.e('❌ Error force re-sending token: $e');
      _logger.e('Stack trace: $stackTrace');
      return false;
    }
  }
}
