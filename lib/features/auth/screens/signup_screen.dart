// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  static final routeName = "/signup_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              const SignupHeader(),
              SizedBox(height: 30.h),
              const NameField(),
              SizedBox(height: 15.h),
              const EmailField(),
              SizedBox(height: 15.h),
              const PasswordField(),
              SizedBox(height: 10.h),
              const ConfirmPasswordField(),
              SizedBox(height: 30.h),
              CustomButtom(
                text: "SIGN UP",
                onTap: () => context.push('/login_screen'),
              ),
              SizedBox(height: 20.h),
              const SignupBottomText(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      "Sign Up in to continue",
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class NameField extends StatelessWidget {
  const NameField({super.key});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        hintText: "Name",
        prefixIcon: const Icon(Icons.person, color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({super.key});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        hintText: "Email",
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        hintText: "Password",
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({super.key});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        hintText: "Confirm Password",
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class SignupBottomText extends StatelessWidget {
  const SignupBottomText({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already Sign Up?",
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => context.push('/login_screen'),
                child: Text(
                  " Signin",
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