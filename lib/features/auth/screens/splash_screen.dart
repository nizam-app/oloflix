// Flutter imports:
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';

import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:Oloflix/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Oloflix/features/Notification/screen/push_notification_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static final routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void loginCheck() async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String? email = await _pref.getString("email");
    String? token = await _pref.getString("token");

    // ✅ If user is already logged in, send FCM token to backend
    if (email != null && token != null && token.isNotEmpty) {
      try {
        debugPrint('🔥 User already logged in. Sending FCM token...');
        await PushNotificationManager.init(authToken: token);
        debugPrint('✅ FCM token sent successfully on app start');
      } catch (e) {
        debugPrint('⚠️ Failed to send FCM token on app start: $e');
      }
    }

    Future.delayed(const Duration(seconds: 3), () {
     if (email != null && token != null ) { context.go(HomeScreen.routeName); }
     else{
       context.go(HomeScreen.routeName);
      // context.go(LoginScreen.routeName);
     }
     // GoRouter navigation
    });
    
  }
  @override
  void initState() {
    super.initState();
    loginCheck() ;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // App Logo with animation effect
              Hero(
                tag: 'app_logo',
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.red.withOpacity(0.3),
                  //       blurRadius: 30,
                  //       spreadRadius: 10,
                  //     ),
                  //   ],
                  // ),
                  child: Image.asset(
                    "assets/images/Logo.png",
                    width: 180.w,
                    height: 180.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              SizedBox(height: 30.h),
              
              // App Name
              // Text(
              //   "OLOFLIX",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 36.sp,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 4,
              //     shadows: [
              //       Shadow(
              //         color: Colors.red.withOpacity(0.5),
              //         blurRadius: 10,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // SizedBox(height: 8.h),
              //
              // // Tagline
              // Text(
              //   "Stream Your Favorites",
              //   style: TextStyle(
              //     color: AllColor.white70,
              //     fontSize: 14.sp,
              //     fontWeight: FontWeight.w400,
              //     letterSpacing: 1.5,
              //   ),
              // ),
              //
              const Spacer(flex: 2),
              
              // Loading indicator
              SizedBox(
                width: 40.w,
                height: 40.h,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.red.shade600,
                  ),
                ),
              ),
              
              SizedBox(height: 20.h),
              // Version
              Text(
                "v3.0.2",
                style: TextStyle(
                  color: AllColor.white70.withOpacity(0.5),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}