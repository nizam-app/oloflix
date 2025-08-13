import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_jango/core/constants/color_control/all_color.dart';

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF171029),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 20.w,
            children: const [
              FooterLink("About"),
              FooterLink("Terms Of Use"),
              FooterLink("Privacy Policy"),
              FooterLink("Pricing & Refunds"),
              FooterLink("Contact"),
              FooterLink("Delete Account"),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "Copyright © 2025 oloflix.tv | Built by turgidWEB.COM",
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ),
          SizedBox(height: 30.h),
          Text(
            "Connect with us",
            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 35.w,
                height: 35.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.alternate_email, color: Colors.black),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 35.w,
                height: 35.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;

  const FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: AllColor.white70, fontSize: 13.sp, ),
    );
  }
}