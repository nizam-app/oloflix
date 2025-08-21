import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
class BaseWidgetTupperBotton extends StatelessWidget {
  const BaseWidgetTupperBotton({super.key, required this.child2,  this.child1});
  final Widget child2;
  final Widget? child1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      body: SafeArea(child:
      SingleChildScrollView(
        child: Column(
          children: [

            CustomHomeTopperSection(),
            ?child1 ,
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w)    ,
              child: child2,
            ),
            
            FooterSection()
          ],
        ),
      ) ),
    );
  }
}