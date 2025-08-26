import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:Oloflix/core/constants/api_control/global_api.dart';
import 'package:Oloflix/core/utils/movies/go_to_details_screen.dart';
import 'package:Oloflix/features/subscription/screen/ppv_subscription.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/widget/custom_primium_button.dart';
import 'package:go_router/go_router.dart';

class CustomMoviCard extends StatelessWidget {
  final MovieDetailsModel movie;

  const CustomMoviCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: (){
                              final id = movie.id;
            goToDetailsScreen(context: context, id:id);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            width: 180.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              image: DecorationImage(
                image: NetworkImage("${api}${movie.videoImageThumb}"), // 👈 ডাইনামিক image
                fit: BoxFit.cover,
              ),
            ),
            clipBehavior: Clip.antiAlias,
          ),
        ),

        // Premium Button / PPV Badge
       if (movie.videoAccess == "Paid")Positioned(
          top: 8.h,
          right: 18.w,
          child: GestureDetector(
            onTap: () {
              context.push(SubscriptionPlanScreen.routeName);
            },
              child: CustomPrimiumButton()),
        ),
        if (movie.videoAccess == "ppv")Positioned(
          top: 8.h,
          right: 18.w,
          child: GestureDetector(
              onTap: () {
                context.push("${PPVSubscriptionPlanScreen.routeName}");
              },
              child: CustomPrimiumButton()),
        ),
      ],
    );
  }
}