
import 'global_api.dart';

class NotificationApi {
  static final String _base_api = "${api}api";
  
  // ✅ Device token endpoints
  static final String deviceToken = "$_base_api/device-token";
  
  // ✅ Push notification endpoints
  static final String pushTest = "$_base_api/push/test";
  static final String pushUser = "$_base_api/push/user";
  
  // ✅ Notification endpoints
  static final String notifications = "$_base_api/notifications";
  static String notificationRead(int id) => "$_base_api/notifications/$id/read";
  static String notificationUnread(int id) => "$_base_api/notifications/$id/unread";
  static final String notificationsReadAll = "$_base_api/notifications/read-all";
  static String notificationDelete(int id) => "$_base_api/notifications/$id";

}
