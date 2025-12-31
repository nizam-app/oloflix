import 'package:firebase_messaging/firebase_messaging.dart';
import '../data/fcm_token_service.dart';

class PushNotificationManager {
  static Future<void> init({
    required String authToken,
    String platform = 'android',
  }) async {
    final fm = FirebaseMessaging.instance;

    final settings = await fm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('🔔 permission: ${settings.authorizationStatus}');

    final String? token = await fm.getToken();
    print('🔥 FCM TOKEN => $token');

    if (token == null || token.isEmpty) {
      print('❌ FCM token null/empty');
      return;
    }

    await FcmTokenService.sendToken(
      fcmToken: token,
      authToken: authToken,
      platform: platform,
    );

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print('♻️ TOKEN REFRESH => $newToken');

      if (newToken.isEmpty) return;

      await FcmTokenService.sendToken(
        fcmToken: newToken,
        authToken: authToken,
        platform: platform,
      );
    });
  }
}
