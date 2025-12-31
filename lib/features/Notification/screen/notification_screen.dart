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
import 'package:firebase_messaging/firebase_messaging.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';

import 'package:Oloflix/features/Notification/model/notifications_model.dart';

import '../../../core/constants/api_control/token_store.dart';
import '../data/fcm_token_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static final routeName = "/notification_screen";

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationsModel> _items = [
    NotificationsModel(
      id: 1,
      icon: Icons.info_outline,
      title: "Welcome to Oloflix!",
      message: "Stay tuned for updates and announcements.",
      time: "Just now",
    ),
  ];

  String _authToken = "";

  @override
  void initState() {
    super.initState();

    _loadToken();
    _listenForegroundPush();
  }

  Future<void> _loadToken() async {
    final t = await TokenStorage.get();
    setState(() => _authToken = t);
    print("✅ LOADED TOKEN => ${_authToken.isEmpty ? 'EMPTY' : 'OK'}");
  }

  void _listenForegroundPush() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title =
          message.notification?.title ?? message.data['title'] ?? 'Notification';
      final body =
          message.notification?.body ?? message.data['body'] ?? '';

      setState(() {
        _items.insert(
          0,
          NotificationsModel(
            id: DateTime.now().millisecondsSinceEpoch,
            icon: Icons.notifications_active_outlined,
            title: title.toString(),
            message: body.toString(),
            time: "Now",
          ),
        );
      });

      print("🔔 PUSH RECEIVED => $title | $body");
    });
  }

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
              _buildNotificationContent(_items),

              // ✅ DEV TEST (চাইলে রাখো, production এ remove)
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => FcmTokenService.pushTest(),
                        child: const Text("Test Push"),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_authToken.isEmpty) {
                            print("❌ authToken empty. login token set kor");
                            return;
                          }
                          FcmTokenService.pushUser(authToken: _authToken);
                        },
                        child: const Text("User Push"),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60.h),
              FooterSection(),
            ],
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
