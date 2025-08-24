// Flutter imports:
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:Oloflix/features/auth/screens/forgod_screen.dart';
import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:Oloflix/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    Future.delayed(const Duration(seconds: 3), () {
     if (email != null && token != null ) { context.go(BottomNavBar.routeName); }
     else{
       context.go(LoginScreen.routeName);
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
      body: Padding(
        padding: EdgeInsets.all(3.r),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Image.asset("assets/images/Logo.png"),
              SizedBox(height: 10.h),
              Spacer(),
              const CircularProgressIndicator(),
              SizedBox(height: 10.h),
              Text("v1.1.0",style: TextStyle(color: AllColor.white70),)     ,
              SizedBox(height: 20.h,)
            ],
          ),
        ),
      ),
    );
  }
}