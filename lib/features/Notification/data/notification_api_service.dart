import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/notification_api_model.dart';
import '../../../core/constants/api_control/notification_api.dart';

class NotificationApiService {

  /// Fetch notifications from backend
  static Future<NotificationApiResponse?> fetchNotifications({
    required String authToken,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final url = '${NotificationApi.notifications}?page=$page&per_page=$perPage';
      debugPrint('📤 Fetching notifications from API...');
      debugPrint('📍 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      debugPrint('📥 Notifications Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          final jsonData = jsonDecode(response.body);
          debugPrint('✅ Notifications fetched successfully');
          debugPrint('📊 Response structure: ${jsonData.keys}');
          
          // Check if response has expected structure
          if (jsonData['status'] == null) {
            debugPrint('⚠️ Warning: Response missing "status" field');
          }
          if (jsonData['data'] == null) {
            debugPrint('⚠️ Warning: Response missing "data" field');
          }
          if (jsonData['meta'] == null) {
            debugPrint('⚠️ Warning: Response missing "meta" field');
          }
          
          final responseObj = NotificationApiResponse.fromJson(jsonData);
          debugPrint('📊 Total notifications: ${responseObj.meta.total}');
          debugPrint('📊 Unread count: ${responseObj.meta.unreadCount}');
          debugPrint('📊 Notifications in list: ${responseObj.data.length}');
          
          return responseObj;
        } catch (e, stackTrace) {
          debugPrint('❌ Error parsing notification response: $e');
          debugPrint('❌ Stack trace: $stackTrace');
          debugPrint('❌ Response body: ${response.body}');
          return null;
        }
      } else {
        debugPrint('❌ Failed to fetch notifications: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        
        // Handle specific error cases
        if (response.statusCode == 401) {
          debugPrint('❌ Unauthorized - Token may be invalid or expired');
        } else if (response.statusCode == 404) {
          debugPrint('❌ Not found - API endpoint may be incorrect');
        }
        
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching notifications: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Mark notification as read
  static Future<bool> markAsRead({
    required String authToken,
    required int notificationId,
  }) async {
    try {
      final url = NotificationApi.notificationRead(notificationId);
      debugPrint('📤 Marking notification $notificationId as read...');
      debugPrint('📍 URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      debugPrint('📥 Mark Read Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        debugPrint('✅ Notification marked as read');
        debugPrint('📊 Response: ${jsonData['message']}');
        return true;
      } else {
        debugPrint('❌ Failed to mark as read: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark notification as unread
  static Future<bool> markAsUnread({
    required String authToken,
    required int notificationId,
  }) async {
    try {
      final url = NotificationApi.notificationUnread(notificationId);
      debugPrint('📤 Marking notification $notificationId as unread...');
      debugPrint('📍 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      debugPrint('📥 Mark Unread Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        debugPrint('✅ Notification marked as unread');
        debugPrint('📊 Response: ${jsonData['message']}');
        return true;
      } else {
        debugPrint('❌ Failed to mark as unread: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error marking notification as unread: $e');
      return false;
    }
  }

  /// Mark all notifications as read
  static Future<bool> markAllAsRead({
    required String authToken,
  }) async {
    try {
      debugPrint('📤 Marking all notifications as read...');
      debugPrint('📍 URL: ${NotificationApi.notificationsReadAll}');

      final response = await http.post(
        Uri.parse(NotificationApi.notificationsReadAll),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      debugPrint('📥 Mark All Read Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('✅ All notifications marked as read');
        return true;
      } else {
        debugPrint('❌ Failed to mark all as read: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error marking all as read: $e');
      return false;
    }
  }

  /// Delete notification
  static Future<bool> deleteNotification({
    required String authToken,
    required int notificationId,
  }) async {
    try {
      final url = NotificationApi.notificationDelete(notificationId);
      debugPrint('📤 Deleting notification $notificationId...');
      debugPrint('📍 URL: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      debugPrint('📥 Delete Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('✅ Notification deleted');
        return true;
      } else {
        debugPrint('❌ Failed to delete notification: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error deleting notification: $e');
      return false;
    }
  }
}

