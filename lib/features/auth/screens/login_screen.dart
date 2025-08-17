// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static final routeName = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 30.h),
              _buildEmailField(),
              SizedBox(height: 15.h),
              _buildPasswordField(),
              SizedBox(height: 10.h),
              _buildOptionsRow(context),
              SizedBox(height: 30.h),
              CustomButtom(
                text: "LOGIN",
                onTap: () => context.push(BottomNavBar.routeName),
              ),
              SizedBox(height: 20.h),
              _buildSignupText(context),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sign in to continue",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(BottomNavBar.routeName);
              },
              child: Text(
                "Skip",
                style: TextStyle(color: Colors.pinkAccent, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        hintText: "Email",
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        hintText: "Password",
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (value) {
                setState(() => rememberMe = value!);
              },
              checkColor: Colors.black,
              activeColor: Colors.white,
            ),
            Text("Remember Me", style: TextStyle(color: Colors.white)),
          ],
        ),
        TextButton(
          onPressed: () {
            context.push("/forgot_screen");
          },
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't Have an Account? ",
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => context.push('/signup_screen'),
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.orange, fontSize: 13.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}