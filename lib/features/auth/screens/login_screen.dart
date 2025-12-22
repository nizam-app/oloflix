// Flutter imports:
import 'package:Oloflix/features/auth/logic/loging_controller.dart';
import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';
import 'package:Oloflix/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static final routeName = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
    
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
              Obx(
          () => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : CustomButtom(
            text: "LOGIN",
            onTap: () {
              controller.login(
                context,
                emailCtrl.text.trim(),
                passCtrl.text.trim(),
              );
            },
          ),
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
                context.go(HomeScreen.routeName);
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
      controller: emailCtrl,
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
      controller: passCtrl,
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
        Obx(
  () => Row(
    children: [
      Checkbox(
        value: controller.rememberMe.value,
        onChanged: (val) => controller.rememberMe.value = val ?? false,
        checkColor: Colors.black,
        activeColor: Colors.white,
      ),
      const SizedBox(width: 5),
      Text("Remember Me", style: TextStyle(color: Colors.white)),
    ],
  ),
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