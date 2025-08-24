import 'dart:math' as math;
import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:Oloflix/features/profile/logic/login_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/controller/bottom_controller.dart';
import 'package:Oloflix/features/home/screens/home_screen.dart';
import 'package:Oloflix/features/live/screen/live_screen.dart';
import 'package:Oloflix/features/ppv/screen/ppv_screen.dart';
import 'package:Oloflix/features/profile/screen/profile_screen.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  static const String routeName = "/bottomNavBar";
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const PpvScreen(),
    const LiveScreen(),
    const ProfileScreen(),
  ];

  Widget _navItem(IconData icon, String label, bool isActive) {
    final color = isActive ? AllColor.white : AllColor.white.withOpacity(0.7);
    return Padding(
      padding:  EdgeInsets.all(3.0.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp, color: color),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp, // ছোট রাখো যাতে 75 এর মধ্যে ফিট করে
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ref.watch(selectedIndexProvider);
    final double navHeight = math.min(70.h, 75.0); // টেক্সট রাখায় একটু বেশি, তবু ≤ 75

    return Scaffold(
      body: _pages.elementAt(selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: selectedIndex,
        height: navHeight,
        items: <Widget>[
          _navItem(FontAwesomeIcons.homeUser, "Home", selectedIndex == 0),
          _navItem(FontAwesomeIcons.eye,       "PPV",  selectedIndex == 1),
          _navItem(Icons.live_tv,              "Live", selectedIndex == 2),
          _navItem(CupertinoIcons.profile_circled, "Account", selectedIndex == 3),
        ],
        color: AllColor.black,
        buttonBackgroundColor: AllColor.orange,
        backgroundColor: AllColor.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),

        onTap: (index) async {
          // শুধু Account (index 3) এর জন্য login guard
          if (index == 3) {
            final loggedIn = await AuthHelper.isLoggedIn();
            if (!loggedIn) {
              if (mounted) context.push(LoginScreen.routeName);
              return; // index change হবে না
            }
          }
          ref.read(selectedIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}