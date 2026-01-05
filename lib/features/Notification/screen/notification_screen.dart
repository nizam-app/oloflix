// // Flutter imports:
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// // Project imports:
// import 'package:Oloflix/core/widget/aboute_fooder.dart';
// import 'package:Oloflix/core/widget/app_drawer.dart';
// import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
// import 'package:Oloflix/core/constants/color_control/all_color.dart';
//
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});
//   static final routeName = "/notification_screen";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: AppDrawer(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomHomeTopperSection(),
//               SizedBox(height: 20.h),
//               _buildNotificationHeader(),
//               SizedBox(height: 20.h),
//               _buildNotificationContent(),
//               SizedBox(height: 60.h),
//               FooterSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // --------------------------- Custom Widgets ---------------------------
//
// /// Builds the header section for the Notification screen.
// Widget _buildNotificationHeader() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         decoration: BoxDecoration(
//           color: AllColor.orange,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           "NOTIFICATIONS",
//           style: TextStyle(
//             fontSize: 16.sp,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ],
//   );
// }
//
// /// Builds the notification content placeholder.
// Widget _buildNotificationContent() {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 16.w),
//     child: Column(
//       children: [
//         _buildNotificationItem(
//           icon: Icons.info_outline,
//           title: "Welcome to Oloflix!",
//           message: "Stay tuned for updates and announcements.",
//           time: "Just now",
//         ),
//         Divider(height: 30.h),
//         _buildNotificationItem(
//           icon: Icons.movie_outlined,
//           title: "New Content Available",
//           message: "Check out our latest movies and shows.",
//           time: "1 hour ago",
//         ),
//         Divider(height: 30.h),
//         _buildNotificationItem(
//           icon: Icons.live_tv,
//           title: "Live Stream Starting Soon",
//           message: "Your favorite show will be live in 30 minutes.",
//           time: "2 hours ago",
//         ),
//       ],
//     ),
//   );
// }
//
// /// Builds a single notification item.
// Widget _buildNotificationItem({
//   required IconData icon,
//   required String title,
//   required String message,
//   required String time,
// }) {
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         padding: EdgeInsets.all(12.r),
//         decoration: BoxDecoration(
//           color: AllColor.orange.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Icon(
//           icon,
//           color: AllColor.orange,
//           size: 24.sp,
//         ),
//       ),
//       SizedBox(width: 12.w),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: AllColor.black,
//               ),
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               message,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               time,
//               style: TextStyle(
//                 fontSize: 10.sp,
//                 color: Colors.grey[400],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/features/Notification/model/notifications_model.dart';
import 'package:Oloflix/core/constants/api_control/token_store.dart';
import '../data/fcm_token_service.dart';
import '../data/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static final routeName = "/notification_screen";

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationsModel> _items = [];
  String _authToken = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadStoredNotifications();
  }

  Future<void> _loadToken() async {
    final t = await TokenStorage.get();
    setState(() => _authToken = t);
    print("✅ LOADED TOKEN => ${_authToken.isEmpty ? 'EMPTY' : 'OK'}");
  }

  Future<void> _loadStoredNotifications() async {
    setState(() => _isLoading = true);
    
    try {
      final stored = await NotificationService.getStoredNotifications();
      
      final List<NotificationsModel> notifications = stored.map((item) {
        return NotificationsModel(
          id: item['id'] ?? DateTime.now().millisecondsSinceEpoch,
          icon: item['read'] == true 
              ? Icons.notifications_outlined 
              : Icons.notifications_active_outlined,
          title: item['title'] ?? 'Notification',
          message: item['body'] ?? '',
          time: _formatTimestamp(item['timestamp']),
        );
      }).toList();

      // Add welcome notification if no notifications exist
      if (notifications.isEmpty) {
        notifications.add(
          NotificationsModel(
            id: 1,
            icon: Icons.info_outline,
            title: "Welcome to Oloflix!",
            message: "Stay tuned for updates and announcements.",
            time: "Just now",
          ),
        );
      }

      setState(() {
        _items = notifications;
        _isLoading = false;
      });

      print("✅ Loaded ${_items.length} notifications from storage");
    } catch (e) {
      print("❌ Error loading notifications: $e");
      setState(() {
        _items = [
          NotificationsModel(
            id: 1,
            icon: Icons.info_outline,
            title: "Welcome to Oloflix!",
            message: "Stay tuned for updates and announcements.",
            time: "Just now",
          ),
        ];
        _isLoading = false;
      });
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final Duration difference = DateTime.now().difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Just now';
    }
  }

  Future<void> _refreshNotifications() async {
    await _loadStoredNotifications();
  }

  Future<void> _clearAllNotifications() async {
    await NotificationService.clearAll();
    await _loadStoredNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshNotifications,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHomeTopperSection(),
                SizedBox(height: 20.h),
                _buildNotificationHeader(),
                SizedBox(height: 20.h),

                // Loading indicator
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  _buildNotificationContent(_items),

                // Clear all button
                if (!_isLoading && _items.length > 1)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: _clearAllNotifications,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear All Notifications'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ),

                // ✅ DEV TEST BUTTONS
                 SizedBox(height: 400.h),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                //   child: Column(
                //     children: [
                //       Row(
                //         children: [
                //           Expanded(
                //             child: ElevatedButton(
                //               onPressed: () => FcmTokenService.pushTest(),
                //               style: ElevatedButton.styleFrom(
                //                 backgroundColor: AllColor.orange,
                //               ),
                //               child: const Text("Test Push"),
                //             ),
                //           ),
                //           SizedBox(width: 12.w),
                //           Expanded(
                //             child: ElevatedButton(
                //               onPressed: () {
                //                 if (_authToken.isEmpty) {
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     const SnackBar(
                //                       content: Text('Please login first'),
                //                       backgroundColor: Colors.red,
                //                     ),
                //                   );
                //                   return;
                //                 }
                //                 FcmTokenService.pushUser(authToken: _authToken);
                //               },
                //               style: ElevatedButton.styleFrom(
                //                 backgroundColor: AllColor.orange,
                //               ),
                //               child: const Text("User Push"),
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(height: 12.h),
                //       // ElevatedButton.icon(
                //       //   onPressed: _refreshNotifications,
                //       //   icon: const Icon(Icons.refresh),
                //       //   label: const Text('Refresh Notifications'),
                //       //   style: ElevatedButton.styleFrom(
                //       //     backgroundColor: Colors.green,
                //       //     minimumSize: Size(double.infinity, 40.h),
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),


                FooterSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------- UI same ---------------------------

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

Widget _buildNotificationContent(List<NotificationsModel> items) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _buildNotificationItem(
            icon: items[i].icon,
            title: items[i].title,
            message: items[i].message,
            time: items[i].time,
          ),
          if (i != items.length - 1) Divider(height: 30.h),
        ],
      ],
    ),
  );
}

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
        child: Icon(icon, color: AllColor.orange, size: 24.sp),
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
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 4.h),
            Text(
              time,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    ],
  );
}
