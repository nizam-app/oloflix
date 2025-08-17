import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';

class CustomPrimiumButton extends StatelessWidget {
  const CustomPrimiumButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: AllColor.orange,
        shape: BoxShape.circle,
      ),
      child:  FaIcon(  FontAwesomeIcons.crown
        , // Using a baseball icon as a placeholder for the crown
        color: AllColor.white,
        size: 15.sp, // Use .sp for responsive font size
      ),
    );
  }
}