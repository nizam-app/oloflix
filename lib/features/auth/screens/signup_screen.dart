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
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButtom(
                      text: "SIGN UP",
                      onTap: () {
                       context.push("/login_screen");
                      },
                    )),
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





// // Flutter imports:
// import 'package:Oloflix/features/auth/logic/signup_controller.dart';
// import 'package:flutter/material.dart';

// // Package imports:
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';

// // Project imports:
// import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//   static final routeName = "/signup_screen";

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final SignupController controller = Get.put(SignupController());
//   final nameCtrl  = TextEditingController(); 
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   final confrimPassCtrl =TextEditingController(); 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               SizedBox(height: 50.h),
//     signupHeader(),
//     SizedBox(height: 30.h),
//     nameField(nameCtrl),
//     SizedBox(height: 15.h),
//     emailField(emailCtrl),
//     SizedBox(height: 15.h),
//     passwordField(passCtrl),
//     SizedBox(height: 10.h),
//     confirmPasswordField(confirmPassCtrl),
//     SizedBox(height: 30.h),
//     Obx(() => controller.isLoading.value
//         ? const Center(child: CircularProgressIndicator())
//         : CustomButtom(
//             text: "SIGN UP",
//             onTap: () {
//               controller.signup(
//                 name: nameCtrl.text.trim(),
//                 email: emailCtrl.text.trim(),
//                 password: passCtrl.text.trim(),
//                 confirmPassword: confirmPassCtrl.text.trim(),
//                 saveCredentials: false,
//               );
//             },
//           )),
//     SizedBox(height: 20.h),
//     signupBottomText(context),
//     SizedBox(height: 30.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget signupHeader() {
//   return Text(
//     "Sign Up to continue",
//     style: TextStyle(
//       fontSize: 22.sp,
//       fontWeight: FontWeight.bold,
//       color: Colors.white,
//     ),
//   );
// }

// Widget nameField(TextEditingController controller) {
//   return TextFormField(
//     controller: controller,
//     style: TextStyle(color: Colors.white),
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: const Color(0xFF1F1F1F),
//       hintText: "Name",
//       prefixIcon: const Icon(Icons.person, color: Colors.grey),
//       hintStyle: const TextStyle(color: Colors.grey),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8.r),
//         borderSide: BorderSide.none,
//       ),
//     ),
//   );
// }

// Widget emailField(TextEditingController controller) {
//   return TextFormField(
//     controller: controller,
//     style: const TextStyle(color: Colors.white),
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: const Color(0xFF1F1F1F),
//       hintText: "Email",
//       prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
//       hintStyle: const TextStyle(color: Colors.grey),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8.r),
//         borderSide: BorderSide.none,
//       ),
//     ),
//   );
// }

// Widget passwordField(TextEditingController controller) {
//   return TextFormField(
//     controller: controller,
//     obscureText: true,
//     style: const TextStyle(color: Colors.white),
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: const Color(0xFF1F1F1F),
//       hintText: "Password",
//       prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//       hintStyle: const TextStyle(color: Colors.grey),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8.r),
//         borderSide: BorderSide.none,
//       ),
//     ),
//   );
// }

// Widget confirmPasswordField(TextEditingController controller) {
//   return TextFormField(
//     controller: controller,
//     obscureText: true,
//     style: const TextStyle(color: Colors.white),
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: const Color(0xFF1F1F1F),
//       hintText: "Confirm Password",
//       prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//       hintStyle: const TextStyle(color: Colors.grey),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8.r),
//         borderSide: BorderSide.none,
//       ),
//     ),
//   );
// }

// Widget signupBottomText(BuildContext context) {
//   return Center(
//     child: RichText(
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: "Already Signed Up?",
//             style: TextStyle(color: Colors.white, fontSize: 13.sp),
//           ),
//           WidgetSpan(
//             child: GestureDetector(
//               onTap: () => context.push('/login_screen'),
//               child: Text(
//                 " Sign In",
//                 style: TextStyle(color: Colors.orange, fontSize: 13.sp),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// }

// class SignupHeader extends StatelessWidget {
//   const SignupHeader({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "Sign Up in to continue",
//       style: TextStyle(
//         fontSize: 22.sp,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     );
//   }
// }

// class NameField extends StatelessWidget {
//   const NameField({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       style:  TextStyle(color: Colors.white),
     
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFF1F1F1F),
//         hintText: "Name",
//         prefixIcon: const Icon(Icons.person, color: Colors.grey),
//         hintStyle: const TextStyle(color: Colors.grey),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.r),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

// class EmailField extends StatelessWidget {
//   const EmailField({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       style: const TextStyle(color: Colors.white),
      
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFF1F1F1F),
//         hintText: "Email",
//         prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
//         hintStyle: const TextStyle(color: Colors.grey),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.r),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

// class PasswordField extends StatelessWidget {
//   const PasswordField({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       obscureText: true,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFF1F1F1F),
//         hintText: "Password",
//         prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//         hintStyle: const TextStyle(color: Colors.grey),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.r),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

// class ConfirmPasswordField extends StatelessWidget {
//   const ConfirmPasswordField({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       obscureText: true,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFF1F1F1F),
//         hintText: "Confirm Password",
//         prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//         hintStyle: const TextStyle(color: Colors.grey),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.r),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

// class SignupBottomText extends StatelessWidget {
//   const SignupBottomText({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: "Already Sign Up?",
//               style: TextStyle(color: Colors.white, fontSize: 13.sp),
//             ),
//             WidgetSpan(
//               child: GestureDetector(
//                 onTap: () => context.push('/login_screen'),
//                 child: Text(
//                   " Signin",
//                   style: TextStyle(color: Colors.orange, fontSize: 13.sp),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }