import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/base_widget_tupper_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MoviesDetailScreen extends StatelessWidget {
  const MoviesDetailScreen({super.key});
  static const String routeName = '/moviesDetailScreen';
  @override
  Widget build(BuildContext context) {
    return BaseWidgetTupperBotton(
      child1: DateilsImage(),
      child2: CustomDescription(),
    );
  }
}

class CustomDescription extends StatelessWidget {
  const CustomDescription({super.key});

  @override
  Widget build(BuildContext context) {
    // Hard-coded data (replace later with API)
    String title = "Never Enough";
    String language = "English";
    String rating = "10";
    String description =
        "NEVER ENOUGH - After breaking up with her rich boyfriend, Anderson sets a new mission to outdo Lemmy. Dora decides to take up an extravagant lifestyle to surpass her ex and make him jealous.";
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h,)   ,
            // Title
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),

            // Language + Rating pill
            Row(
              children: [
                Text(
                  language,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20.r), // pill shape
                  ),
                  child: Text(
                    rating,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            CustomElevatedbutton(
              title: 'Watch Trailer',
              color: AllColor.orange,
              onPressed: () {},
            ) ,

            // Description
            Text(
              description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

class DateilsImage extends StatelessWidget {
  const DateilsImage({
    super.key,
  
  });



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          child: Image.network(
            "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/fiVW06jE7z9YnO4trhaMEdclSiC.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.h,
          ),
        ),
    
        // Play Button
        Positioned(
          right: 8.w,
          top: 8.h,
          child: CircleAvatar(
            radius: 18.r,
            backgroundColor: Colors.red,
            child: Icon(Icons.play_arrow,
                color: Colors.white, size: 20.sp),
          ),
        ),
    
        // Buttons over poster bottom
        Positioned(
          bottom: 3.h,
          left: 3.w,
          right: 3.w,
          child: Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.h),
                ),
                onPressed: () {},
                icon: Icon(Icons.add, color: Colors.white, size: 18.sp),
                label: Text(
                  "Add to Watchlist",
                  style:
                  TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              ),
              SizedBox(width: 12.w),
              CustomElevatedbutton(title: 'Watch Trailer', color: AllColor.blue,onPressed: (){},),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomElevatedbutton extends StatelessWidget {
  const CustomElevatedbutton({
    super.key, required this.title, required this.color, this.onPressed,
  });
  final String title;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.r),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 12.w, vertical: 8.h),
      ),
      onPressed: onPressed,
      child: Text(
        "$title",
        style:
        TextStyle(color: AllColor.white, fontSize: 13.sp),
      ),
    );
  }
}