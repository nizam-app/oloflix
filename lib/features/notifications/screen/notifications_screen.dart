// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/widget/base_widget_tupper_botton.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static final routeName = "/notifications_screen";

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Placeholder notification data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Movie Added',
      'message': 'Check out our latest PPV movie releases!',
      'time': '2 hours ago',
      'isRead': false,
    },
    {
      'title': 'Subscription Reminder',
      'message': 'Your subscription will expire in 7 days.',
      'time': '1 day ago',
      'isRead': false,
    },
    {
      'title': 'Live Stream Starting',
      'message': 'Your favorite show is about to start live!',
      'time': '2 days ago',
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseWidgetTupperBotton(
      child2: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AllColor.white,
                ),
          ),
          SizedBox(height: 16.h),
          
          // Notifications List
          _notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return _buildNotificationCard(
                      title: notification['title'],
                      message: notification['message'],
                      time: notification['time'],
                      isRead: notification['isRead'],
                      onTap: () {
                        setState(() {
                          _notifications[index]['isRead'] = true;
                        });
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isRead ? AllColor.black.withOpacity(0.3) : AllColor.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isRead ? AllColor.white.withOpacity(0.1) : AllColor.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Icon
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AllColor.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.notifications,
                color: AllColor.orange,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            
            // Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AllColor.white,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: AllColor.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AllColor.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AllColor.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80.sp,
              color: AllColor.white.withOpacity(0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AllColor.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You\'re all caught up!',
              style: TextStyle(
                fontSize: 14.sp,
                color: AllColor.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


