import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
class BaseWidgetTupperBotton extends StatelessWidget {
  const BaseWidgetTupperBotton({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      body: SafeArea(child:Column(
        children: [
          CustomHomeTopperSection(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w)    ,
            child: child,
          ),
          
          FooterSection()
        ],
      ) ),
    );
  }
}