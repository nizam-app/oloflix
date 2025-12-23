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

  /// ShellRoute থেকে আসা child এখানে render হবে
  final Widget child;
  const BottomNavBar({super.key, required this.child});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  int _indexFromLocation(String loc) {
    // location দিয়ে active tab নির্ধারণ
    if (loc.startsWith(ProfileScreen.routeName)) return 3;
    if (loc.startsWith(LiveScreen.routeName)) return 2;
    if (loc.startsWith(PpvScreen.routeName)) return 1;
    return 0; // default -> Home
  }

  String _pathForIndex(int index) {
    switch (index) {
      case 1:
        return PpvScreen.routeName;
      case 2:
        return LiveScreen.routeName;
      case 3:
        return ProfileScreen.routeName;
      case 0:
      default:
        return HomeScreen.routeName;
    }
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    final color = isActive ? AllColor.white : AllColor.white.withOpacity(0.7);
    return Padding(
      padding: EdgeInsets.all(3.0.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp, color: color),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTap(BuildContext context, int index) async {
    // Live tab guard
    if (index == 2) {
      final premium = hasPremium(ref);
      if (!premium) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text("Please purchase the YEARLY subscription to view page!!"),
              ),
            );
        }
        return;
      }
    }

    // Account tab guard
    if (index == 3) {
      final loggedIn = await AuthHelper.isLoggedIn();
      if (!loggedIn) {
        if (mounted) context.push(LoginScreen.routeName);
        return;
      }
    }

    // Navigate & provider sync (তোমার আগের provider-ও রেখে দিলাম)
    final path = _pathForIndex(index);
    if (mounted) {
      context.go(path);
      ref.read(selectedIndexProvider.notifier).state = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final int selectedIndex =
    _indexFromLocation(loc.isEmpty ? HomeScreen.routeName : loc);

    final double navHeight = math.min(70.h, 75.0);

    return Scaffold(
      body: widget.child, // ShellRoute এর বর্তমান child
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: selectedIndex,
        height: navHeight,
        items: <Widget>[
          _navItem(FontAwesomeIcons.homeUser, "Home", selectedIndex == 0),
          _navItem(FontAwesomeIcons.eye, "PPV", selectedIndex == 1),
          _navItem(Icons.live_tv, "Live", selectedIndex == 2),
          _navItem(CupertinoIcons.profile_circled, "Account", selectedIndex == 3),
        ],
        color: AllColor.black,
        buttonBackgroundColor: AllColor.orange,
        backgroundColor: AllColor.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (i) => _onTap(context, i),
      ),
    );
  }
}