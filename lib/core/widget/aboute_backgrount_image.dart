// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:market_jango/core/constants/image_control/image_path.dart';

class AbouteBackgrountImage extends StatelessWidget {
  const AbouteBackgrountImage({super.key, required this.screenName});
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 120.h, // Responsive height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.Mbackground),
            opacity: 0.3,
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 35.h), // Responsive spacing
            Text(
              screenName,
              style: TextStyle(
                fontSize: 24.sp, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Home",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                ),
                Icon(Icons.chevron_right, color: Colors.white70, size: 16.sp),
                Text(
                  screenName,
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
