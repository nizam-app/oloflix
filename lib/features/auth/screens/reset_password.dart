import 'package:Oloflix/features/auth/logic/reset_controller.dart';
import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});
  static final routeName = "/reset_password";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ResetController resetController = Get.put(ResetController());

  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  passwordField(passCtrl),
                  SizedBox(height: 15.h),
                  confirmPasswordField(confirmPassCtrl),
                  SizedBox(height: 30.h),
                  /// Submit Button
                  Obx(() {
                    return CustomButtom(
                      text: resetController.isLoading.value
                          ? "Loading..."
                          : "SUBMIT",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (passCtrl.text == confirmPassCtrl.text) {
                        
                            resetController.isLoading; 

                            context.push('/login_screen');
                          } else {
                            Get.snackbar("Error", "Passwords do not match");
                          }
                        }
                      },
                    );
                  }),

                  SizedBox(height: 20.h),
                  
                  Center(
                    child: GestureDetector(
                      onTap: () => context.push('/login_screen'),
                      child: Text(
                        "Back to Login",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      decoration: fieldDecoration("New Password", Icons.lock_outline),
      validator: (val) {
        if (val == null || val.isEmpty) return "Enter new password";
        if (val.length < 8) return "Password must be at least 6 characters";
        return null;
      },
    );
  }

  Widget confirmPasswordField(TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: fieldDecoration("Confirm Password", Icons.lock_outline),
      validator: (val) {
        if (val == null || val.isEmpty) return "Confirm your password";
        if (val != passCtrl.text) return "Passwords do not match";
        return null;
      },
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
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    );
  }
}
