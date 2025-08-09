import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 ElevatedButtonThemeData  elevatedButtonTheme() {
   return  ElevatedButtonThemeData(
     style: ElevatedButton.styleFrom(// বাটনের ব্যাকগ্রাউন্ড কালার
       foregroundColor: Colors.white,       // টেক্সট কালার
       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(5.r),
       ),
       elevation: 4,
       textStyle: TextStyle(
         fontSize: 15.sp,
         fontWeight: FontWeight.bold,
       ),
minimumSize: Size(40.w, 32.h)
     ),
   );

 }
