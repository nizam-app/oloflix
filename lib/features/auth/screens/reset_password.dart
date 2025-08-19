import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});
  static final routeName ="/reset_password";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

   final passCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              _TitleText(),
              SizedBox(height: 30),
                passwordField(passCtrl),
              SizedBox(height: 10.h),
              confirmPasswordField(confirmPassCtrl),
              SizedBox(height: 30),
              CustomButtom(
                text: "SUBMIT",
                onTap: () {
                  context.push('/login_screen');
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
}


class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Reset Password",
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
