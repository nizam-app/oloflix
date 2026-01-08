// Flutter imports:
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Firebase:
import 'package:firebase_core/firebase_core.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'app.dart';
import 'features/Notification/data/notification_service.dart';

/// Background message handler (must be top-level function)
/// This is called when app is in background or terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🔔 Background message received');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
  
  // On iOS, when app is in background/terminated, the system handles notification display
  // automatically if the payload has proper notification fields.
  // This handler is mainly for processing data payloads.
  
  // Note: For iOS, notifications with notification field in payload will be displayed
  // automatically by the system. This handler processes the data.
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialized');

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request notification permissions
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');
    
    // Enable foreground notification presentation for iOS
    // This allows notifications to show when app is in foreground
    if (Platform.isIOS) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('✅ iOS foreground notification presentation enabled');
      
      // IMPORTANT: Check APNS token availability
      // Getting APNS token will trigger remote notification registration if not already done
      try {
        final apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          debugPrint('✅ APNS token available: ${apnsToken.substring(0, 20)}...');
        } else {
          debugPrint('⚠️ APNS token not yet available - will be retrieved automatically');
        }
      } catch (e) {
        debugPrint('⚠️ Error checking APNS token: $e');
      }
    }

    // Get FCM token with iOS-specific handling
    try {
      String? token;
      
      if (Platform.isIOS) {
        // On iOS, APNS token might not be immediately available
        // Try multiple times with increasing delays
        debugPrint('📱 Waiting for iOS APNS token...');
        
        int retryCount = 0;
        const maxRetries = 5;
        const retryDelays = [500, 1000, 1500, 2000, 3000]; // milliseconds
        
        while (token == null && retryCount < maxRetries) {
          if (retryCount > 0) {
            debugPrint('🔄 Retrying APNS token retrieval (attempt ${retryCount + 1}/$maxRetries)...');
            await Future.delayed(Duration(milliseconds: retryDelays[retryCount - 1]));
          } else {
            await Future.delayed(const Duration(milliseconds: 500));
          }
          
          // Try to get APNS token first
          final apnsToken = await messaging.getAPNSToken();
          if (apnsToken != null) {
            debugPrint('🍎 APNS Token received: ${apnsToken.substring(0, 20)}...');
            token = await messaging.getToken();
            if (token != null) {
              debugPrint('✅ FCM token retrieved successfully on attempt ${retryCount + 1}');
              break;
            }
          }
          
          retryCount++;
        }
        
        // If still no token, setup refresh listener
        if (token == null) {
          debugPrint('⚠️ APNS token not available after $maxRetries attempts, will retry via refresh listener');
          // Listen for token refresh and save it
          FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
            debugPrint('🔄 FCM Token refreshed: $newToken');
            // Save token locally when it becomes available
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('fcm_token', newToken);
              await prefs.setString('fcm_token_timestamp', DateTime.now().toIso8601String());
              debugPrint('💾 FCM token saved locally after refresh');
            } catch (e) {
              debugPrint('⚠️ Could not save refreshed FCM token: $e');
            }
          });
        }
      } else {
        // Android doesn't need APNS token
        token = await messaging.getToken();
      }
      
      if (token != null) {
        debugPrint('🔥 FCM Token (Full): $token');
        debugPrint('🔥 FCM Token Length: ${token.length} characters');
        // Save token locally so it can be used after login
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('fcm_token', token);
          await prefs.setString('fcm_token_timestamp', DateTime.now().toIso8601String());
          debugPrint('💾 FCM token saved locally');
        } catch (e) {
          debugPrint('⚠️ Could not save FCM token locally: $e');
        }
        // Token will be sent to backend after user logs in
      } else {
        debugPrint('⚠️ FCM Token not available yet, will be retrieved later');
      }
    } catch (tokenError) {
      debugPrint('⚠️ Could not get FCM token immediately: $tokenError');
      debugPrint('💡 Token will be retrieved when available');
    }

    // Initialize comprehensive notification service
    await NotificationService.initialize();

    debugPrint('✅ App initialization complete');
  } catch (e, stackTrace) {
    debugPrint('❌ Error during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  runApp(
    const ProviderScope(
      child: ScreenUtilInit(
        designSize: Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        child: App(),
      ),
    ),
  );
}