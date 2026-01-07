import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final Logger _logger = Logger();
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  static Future<void> initialize() async {
    _logger.i('🔔 Initializing Notification Service...');

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Setup message handlers
    _setupMessageHandlers();

    _logger.i('✅ Notification Service initialized');
  }

  /// Initialize local notifications plugin
  static Future<void> _initializeLocalNotifications() async {
    try {
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channel for Android
      await _createNotificationChannel();

      _logger.i('✅ Local notifications initialized');
    } catch (e, stackTrace) {
      _logger.e('❌ Error initializing local notifications: $e');
      _logger.e('Stack trace: $stackTrace');
    }
  }

  /// Create Android notification channel
  static Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'oloflix_channel',
      'Oloflix Notifications',
      description: 'Notifications from Oloflix app',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _logger.i('✅ Notification channel created');
  }

  /// Setup Firebase message handlers
  static void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle initial message when app is opened from terminated state
    _handleInitialMessage();
  }

  /// Handle foreground messages (app is open)
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _logger.i('🔔 Foreground message received');
    _logger.i('Title: ${message.notification?.title}');
    _logger.i('Body: ${message.notification?.body}');
    _logger.i('Data: ${message.data}');

    // Save notification to local storage
    await _saveNotification(message);

    // Show local notification
    await _showLocalNotification(message);
  }

  /// Handle notification tap
  static Future<void> _handleNotificationTap(RemoteMessage message) async {
    _logger.i('👆 Notification tapped');
    _logger.i('Title: ${message.notification?.title}');
    _logger.i('Data: ${message.data}');

    // Save notification
    await _saveNotification(message);

    // TODO: Navigate to specific screen based on message data
    // Example: if (message.data['type'] == 'movie') { navigate to movie }
  }

  /// Handle initial message (app opened from notification while terminated)
  static Future<void> _handleInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _logger.i('📬 App opened from notification');
      await _handleNotificationTap(initialMessage);
    }
  }

  /// Handle notification tap from local notification
  static void _onNotificationTapped(NotificationResponse response) {
    _logger.i('👆 Local notification tapped');
    _logger.i('Payload: ${response.payload}');

    // TODO: Navigate based on payload
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _logger.d('Notification data: $data');
        // Handle navigation
      } catch (e) {
        _logger.e('Error parsing notification payload: $e');
      }
    }
  }

  /// Show local notification
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) {
        _logger.w('⚠️ No notification data in message');
        return;
      }

      const androidDetails = AndroidNotificationDetails(
        'oloflix_channel',
        'Oloflix Notifications',
        channelDescription: 'Notifications from Oloflix app',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title ?? 'Oloflix',
        notification.body ?? '',
        details,
        payload: jsonEncode(message.data),
      );

      _logger.i('✅ Local notification shown');
    } catch (e, stackTrace) {
      _logger.e('❌ Error showing local notification: $e');
      _logger.e('Stack trace: $stackTrace');
    }
  }

  /// Save notification to local storage
  static Future<void> _saveNotification(RemoteMessage message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getStoredNotifications();

      final newNotification = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': message.notification?.title ?? message.data['title'] ?? 'Notification',
        'body': message.notification?.body ?? message.data['body'] ?? '',
        'data': message.data,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };

      notifications.insert(0, newNotification);

      // Keep only last 50 notifications
      if (notifications.length > 50) {
        notifications.removeRange(50, notifications.length);
      }

      await prefs.setString('notifications', jsonEncode(notifications));
      _logger.i('✅ Notification saved to storage');
    } catch (e) {
      _logger.e('❌ Error saving notification: $e');
    }
  }

  /// Get stored notifications from local storage
  static Future<List<Map<String, dynamic>>> getStoredNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getString('notifications');

      if (notificationsJson == null || notificationsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(notificationsJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      _logger.e('❌ Error getting stored notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  static Future<void> markAsRead(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getStoredNotifications();

      for (var notification in notifications) {
        if (notification['id'] == id) {
          notification['read'] = true;
          break;
        }
      }

      await prefs.setString('notifications', jsonEncode(notifications));
      _logger.i('✅ Notification marked as read');
    } catch (e) {
      _logger.e('❌ Error marking notification as read: $e');
    }
  }

  /// Clear all notifications
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notifications');
      await _localNotifications.cancelAll();
      _logger.i('✅ All notifications cleared');
    } catch (e) {
      _logger.e('❌ Error clearing notifications: $e');
    }
  }

  /// Get unread notification count
  static Future<int> getUnreadCount() async {
    try {
      final notifications = await getStoredNotifications();
      return notifications.where((n) => n['read'] == false).length;
    } catch (e) {
      _logger.e('❌ Error getting unread count: $e');
      return 0;
    }
  }

  /// Get FCM token safely (handles iOS APNS token delay)
  /// Returns null if token is not available yet
  static Future<String?> getFCMToken({int retryDelayMs = 500}) async {
    try {
      final messaging = FirebaseMessaging.instance;
      
      if (Platform.isIOS) {
        // On iOS, check if APNS token is available
        _logger.i('📱 Checking for iOS APNS token...');
        
        // Wait a bit for APNS token
        await Future.delayed(Duration(milliseconds: retryDelayMs));
        
        final apnsToken = await messaging.getAPNSToken();
        if (apnsToken == null) {
          _logger.w('⚠️ APNS token not available yet');
          return null;
        }
        
        _logger.i('🍎 APNS Token available: ${apnsToken.substring(0, 20)}...');
      }
      
      final token = await messaging.getToken();
      if (token != null) {
        _logger.i('🔥 FCM Token retrieved successfully');
        _logger.i('Token length: ${token.length} characters');
        _logger.d('Token preview: ${token.substring(0, 30)}...');
      } else {
        _logger.w('⚠️ FCM Token is null');
      }
      
      return token;
    } catch (e) {
      _logger.e('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Listen for FCM token refresh
  static Stream<String> onTokenRefresh() {
    return FirebaseMessaging.instance.onTokenRefresh;
  }
}

