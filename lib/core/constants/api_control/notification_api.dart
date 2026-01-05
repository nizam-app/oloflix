
import 'global_api.dart';

class NotificationApi {
  static final String _base_api = "${api}api";
  // ✅ Save device token
  static final String deviceToken = "$_base_api/device-token";
  // ✅ Dev/Test push
  static final String pushTest = "$_base_api/push/test";
  // ✅ Push to logged-in user
  static final String pushUser = "$_base_api/push/user";

}
