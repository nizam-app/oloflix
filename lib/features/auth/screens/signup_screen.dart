// Flutter imports:
import 'package:Oloflix/features/auth/logic/signup_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  static final routeName = "/signup_screen";

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              signupHeader(),
              SizedBox(height: 30.h),
              nameField(nameCtrl),
              SizedBox(height: 15.h),
              emailField(emailCtrl),
              SizedBox(height: 15.h),
              passwordField(passCtrl),
              SizedBox(height: 10.h),
              confirmPasswordField(confirmPassCtrl),
              SizedBox(height: 30.h),
              Obx(
  () => controller.isLoading.value
      ? const Center(child: CircularProgressIndicator())
      : CustomButtom(
          text: "SIGN UP",
          onTap: () {
            controller.signup(
              context,
              nameCtrl.text.trim(),
              emailCtrl.text.trim(),
              passCtrl.text.trim(),
              confirmPassCtrl.text.trim(),
            );
          },
        ),
),

              SizedBox(height: 20.h),
              signupBottomText(context),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- Widgets -----------------
  Widget signupHeader() {
    return Text(
      "Sign Up to continue",
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget nameField(TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: fieldDecoration("Name", Icons.person),
    );
  }

  Widget emailField(TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: fieldDecoration("Email", Icons.email_outlined),
    );
  }

  Widget passwordField(TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: fieldDecoration("Password", Icons.lock_outline),
    );
  }

  Widget confirmPasswordField(TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: fieldDecoration("Confirm Password", Icons.lock_outline),
    );
  }

  InputDecoration fieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1F1F1F),
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget signupBottomText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already Signed Up?",
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => context.push('/login_screen'),
                child: Text(
                  " Sign In",
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
