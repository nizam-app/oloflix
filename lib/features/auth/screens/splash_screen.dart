import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static final routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
void initState() {
  super.initState();

  Future.delayed(const Duration(seconds: 3), () {
    context.go('/login_screen'); // GoRouter navigation
  });
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
              const CircularProgressIndicator(),
              SizedBox(height: 10.h),
              Text(
                "Oloflix",
                style: TextStyle(fontSize: 25.sp, color: Colors.white),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
