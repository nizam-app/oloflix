// Flutter imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Firebase:
import 'package:firebase_core/firebase_core.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'app.dart';
import 'features/Notification/data/notification_service.dart';

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🔔 Background message: ${message.notification?.title}');
  // Note: Local notifications won't show here automatically
  // The NotificationService will handle this when app opens
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

    // Get FCM token
    final token = await messaging.getToken();
    if (token != null) {
      debugPrint('🔥 FCM Token (Full): $token');
      debugPrint('🔥 FCM Token Length: ${token.length} characters');
      // Token will be sent to backend after user logs in
    } else {
      debugPrint('⚠️ FCM Token is null');
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

