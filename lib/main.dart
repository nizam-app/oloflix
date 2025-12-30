// // Flutter imports:
// import 'package:flutter/material.dart';
//
// // Package imports:
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// // Project imports:
// import 'app.dart';
//
// void main() {
//   runApp(
//     ProviderScope(
//       child: ScreenUtilInit(
//         designSize: const Size(393, 852),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         child: const App(),
//       ),
//     ),
//   );
// }

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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background এ message এলে Firebase init লাগতে পারে
  await Firebase.initializeApp();
  // debug:
  // print('BG message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp();

  // Background notification handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Permission (Android 13+/iOS)
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // FCM Token (এটা backend এ save করবে)
  final token = await messaging.getToken();
  debugPrint('FCM Token: $token');

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');
  });

  // Notification tap -> app opened
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('Opened from notification: ${message.notification?.title}');
  });

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

