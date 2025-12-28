// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static final routeName = "/notification_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              SizedBox(height: 20.h),
              _buildNotificationHeader(),
              SizedBox(height: 20.h),
              _buildNotificationContent(),
              SizedBox(height: 60.h),
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- Custom Widgets ---------------------------

/// Builds the header section for the Notification screen.
Widget _buildNotificationHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AllColor.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "NOTIFICATIONS",
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

/// Builds the notification content placeholder.
Widget _buildNotificationContent() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      children: [
        _buildNotificationItem(
          icon: Icons.info_outline,
          title: "Welcome to Oloflix!",
          message: "Stay tuned for updates and announcements.",
          time: "Just now",
        ),
        Divider(height: 30.h),
        _buildNotificationItem(
          icon: Icons.movie_outlined,
          title: "New Content Available",
          message: "Check out our latest movies and shows.",
          time: "1 hour ago",
        ),
        Divider(height: 30.h),
        _buildNotificationItem(
          icon: Icons.live_tv,
          title: "Live Stream Starting Soon",
          message: "Your favorite show will be live in 30 minutes.",
          time: "2 hours ago",
        ),
      ],
    ),
  );
}

/// Builds a single notification item.
Widget _buildNotificationItem({
  required IconData icon,
  required String title,
  required String message,
  required String time,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AllColor.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          color: AllColor.orange,
          size: 24.sp,
        ),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AllColor.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              time,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

