import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static final routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileTextImages(context),
              SizedBox(height: 20.h),
              customField(context, label: "Name", hint: "John Doe"),
              customField(context, label: "Email", hint: "example@gmail.com"),
              customField(context, label: "Password", hint: "12345678"),
              customField(context, label: "Phone", hint: "+880 1826344872"),
              customField(context, label: "Address", hint: "Dhaka, Bangladesh"),
              customField(context, label: "Profile Images", hint: "upload "),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileTextImages(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30.h),
        Text(
          "Your Profile",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.h),
        Center(
  child: CircleAvatar(
    radius: 50,
    backgroundImage: NetworkImage(
      "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face",
    ),
     child: Icon(Icons.person, size: 50, color: Colors.white.withOpacity(0.5)),
  ),
),
      ],
    );
  }

  Widget customField(
    BuildContext context, {
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1F1F1F),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
