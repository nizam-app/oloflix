// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:market_jango/core/widget/aboute_backgrount_image.dart';
import 'package:market_jango/core/widget/aboute_fooder.dart';
import 'package:market_jango/core/widget/custom_home_topper_section.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const routeName = "/AboutScreen";

  @override
  Widget build(BuildContext context) {
    // Initialize flutter_screenutil
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      // Dark background color
      body: SafeArea(
        child: SingleChildScrollView(
          // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              SizedBox(height: kToolbarHeight - 20.h),
              AbouteBackgrountImage(screenName: "About"),
              Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "Oloflix: - Watch Movies, TV Shows & curated entertainment videos.",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h), // Responsive spacing
                    Text(
                      "With Oloflix, you can enjoy a daily blast of entertainment, including new movies, series, short films, podcasts, documentaries and educative videos. Our app features a range of great tools to enhance your viewing experience.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                        height: 1.5.h, // Responsive line height
                      ),
                    ),
                    SizedBox(height: 16.h), // Responsive spacing
                    Text(
                      "With Oloflix, you can enjoy a daily blast of entertainment, including new movies, series, short films, podcasts, documentaries and educative videos. Our app features a range of great tools to enhance your viewing experience.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                        height: 1.5.h,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "This is your opportunity to navigate different kinds of genres such as Nollywood, documentary, music, comedy, drama, action, fantasy, romance, sports and several educational videos. Access to the Oloflix platform is subscription-based because we offer only premium contents.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                        height: 1.5.h,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "But that's not all, we also offer a wide range of features to enhance your viewing experience. Oloflix App gives you access to a massive library of contents, including Nollywood movies and shows. We have something for everyone, with genres that appeal to different audience.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                        height: 1.5.h,
                      ),
                    ),
                  ],
                ),
              ), // Spacing after the title section
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}
