import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/widget/custom_primium_button.dart';

class CustomMoviCard extends StatelessWidget {
  const CustomMoviCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          width: 180.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            image: DecorationImage(
              image: AssetImage("assets/images/movie1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          // child: Image.asset("assets/images/movie1.jpg",fit: BoxFit.cover,)
        ),

        // PG 15+ top-right
        Positioned(
            top: 8.h,
            right: 18.w,
            child: CustomPrimiumButton()),

        // Left/Right Arrow
      ],
    );
  }
}