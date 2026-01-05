import 'package:flutter/material.dart';

class NotificationsModel {
  final int id;
  final IconData icon;
  final String title;
  final String message;
  final String time;

  NotificationsModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
  });
}
