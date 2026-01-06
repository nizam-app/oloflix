import 'package:flutter/foundation.dart';

class NotificationApiResponse {
  final String status;
  final List<NotificationItem> data;
  final NotificationMeta meta;

  NotificationApiResponse({
    required this.status,
    required this.data,
    required this.meta,
  });

  factory NotificationApiResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Handle case where data might be null or not a list
      List<NotificationItem> notifications = [];
      if (json['data'] != null) {
        if (json['data'] is List) {
          notifications = (json['data'] as List)
              .map((item) {
                try {
                  return NotificationItem.fromJson(item as Map<String, dynamic>);
                } catch (e) {
                  debugPrint('⚠️ Error parsing notification item: $e');
                  return null;
                }
              })
              .whereType<NotificationItem>()
              .toList();
        } else {
          debugPrint('⚠️ Warning: "data" is not a List, it is: ${json['data'].runtimeType}');
        }
      }
      
      return NotificationApiResponse(
        status: json['status']?.toString() ?? '',
        data: notifications,
        meta: NotificationMeta.fromJson(json['meta'] ?? {}),
      );
    } catch (e) {
      debugPrint('❌ Error parsing NotificationApiResponse: $e');
      rethrow;
    }
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String type;
  final int? referenceId;
  final String createdAt;
  final String createdAtFormatted;
  final bool isRead;
  final String? readAt;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final NotificationUser? user;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.referenceId,
    required this.createdAt,
    required this.createdAtFormatted,
    required this.isRead,
    this.readAt,
    this.data,
    this.imageUrl,
    this.user,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      referenceId: json['referenceId'],
      createdAt: json['createdAt'] ?? '',
      createdAtFormatted: json['createdAtFormatted'] ?? '',
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'],
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'],
      user: json['user'] != null
          ? NotificationUser.fromJson(json['user'])
          : null,
    );
  }
}

class NotificationUser {
  final int id;
  final String name;
  final String email;

  NotificationUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory NotificationUser.fromJson(Map<String, dynamic> json) {
    return NotificationUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class NotificationMeta {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int unreadCount;

  NotificationMeta({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.unreadCount,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}

