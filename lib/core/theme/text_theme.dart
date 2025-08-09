import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_jango/core/constants/color_control/all_color.dart';

TextTheme get textTheme {
  return TextTheme(
    titleLarge: TextStyle(
      fontSize: 17.sp,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w800,
      color: AllColor.red
    ),
    titleSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: .4,
    ),
    headlineMedium: TextStyle(fontSize: 16, color: Colors.grey),
  );
}