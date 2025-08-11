import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/core/constants/color_control/all_color.dart';
import 'package:market_jango/core/constants/color_control/theme_color_controller.dart';
import 'package:market_jango/features/about/screen/about_screen.dart';
import 'package:market_jango/features/contact/screen/contact_screen.dart';
import 'package:market_jango/features/delete_account/screen/delete_account_screen.dart';
import 'package:market_jango/features/privacy_policy/screen/privacy_screen.dart';
import 'package:market_jango/features/terms_of/screen/terms_of_use_screen.dart';

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF171029),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 20.w,
            children:  [
              FooterLink(text: 'About', onTap: () {context.push(AboutScreen.routeName);},),
              FooterLink( text: "Terms Of Use", onTap: () {context.push(TermsOfUseScreen.routeName);  },),
              FooterLink( text: "Privacy Policy", onTap: () {context.push(PrivacyScreen.routeName);  },),
              FooterLink( text: "Pricing & Refunds", onTap: () { context.push(PrivacyScreen.routeName); },),
              FooterLink( text: "Contact", onTap: () {context.push(ContactScreen.routeName);  },),
              FooterLink( text: "Delete Account", onTap: () { context.push(DeleteAccountScreen.routeName); },),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "Copyright © 2025 oloflix.tv | Built by turgidWEB.COM",
            style: TextStyle(color: AllColor.white70, fontSize: 12.sp),
          ),
          SizedBox(height: 30.h),
          Text(
            "Connect with us",
            style: TextStyle(color: ThemeColorController.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
               buildCircleAvatar(onTap: () {  }, icon: FontAwesomeIcons.twitter),

              SizedBox(width: 10.w),
             buildCircleAvatar(onTap: (){}, icon: FontAwesomeIcons.instagram)
            ],
          ),
        ],
      ),
    );
  }
  InkWell buildCircleAvatar({required VoidCallback onTap,required IconData icon }) {
    return InkWell(
      onTap:onTap ,
      child: CircleAvatar(
                 backgroundColor:ThemeColorController.white,
                   child: FaIcon(icon, color: Colors.black)),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;

  const FooterLink( {required this.text,required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ,
      child: Text(
        text,
        style: TextStyle(color: AllColor.white70, fontSize: 13.sp, ),
      ),
    );
  }
}