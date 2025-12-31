import 'package:http/http.dart' as http;

import '../../../core/constants/api_control/notification_api.dart';

class FcmTokenService {


  static Future<void> pushTest() async {
    try {
      final res = await http.get(
        Uri.parse(NotificationApi.pushTest),
        headers: {'Accept': 'application/json'},
      );
      print('✅ push/test status: ${res.statusCode}');
      print('✅ push/test body: ${res.body}');
    } catch (e) {
      print('❌ push/test error: $e');
    }
  }

  static Future<void> pushUser({required String authToken}) async {
    try {
      final res = await http.get(
        Uri.parse(NotificationApi.pushUser),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print('✅ push/user status: ${res.statusCode}');
      print('✅ push/user body: ${res.body}');
    } catch (e) {
      print('❌ push/user error: $e');
    }
  }
}
