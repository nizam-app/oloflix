import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/features/auth/widgets/custom_buttom.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  static final routeName = '/forgot_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              _TitleText(),
              SizedBox(height: 30),
              _EmailInputField(),
              SizedBox(height: 30),
              CustomButtom(
                text: "RESET PASSWORD",
                onTap: () {
                  context.push('/login_screen');
                },
              ),
              SizedBox(height: 20),
              _SignupText(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Forgot Password",
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _EmailInputField extends StatelessWidget {
  const _EmailInputField();

  @override
  Widget build(BuildContext context) {
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
}

class _SignupText extends StatelessWidget {
  const _SignupText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't you have an account yet? ",
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => context.push('/login_screen'),
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
