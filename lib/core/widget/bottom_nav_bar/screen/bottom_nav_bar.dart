import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/controller/bottom_controller.dart';
import 'package:Oloflix/features/home/screens/home_screen.dart';
import 'package:Oloflix/features/live/screen/live_screen.dart';
import 'package:Oloflix/features/ppv/screen/ppv_screen.dart';
import 'package:Oloflix/features/profile/screen/profile_screen.dart';


// This is the main page where the custom navigation bar is used.
class BottomNavBar extends ConsumerStatefulWidget {
  static const String routeName = "/bottomNavBar";
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  // We'll use a GlobalKey to access the state of the navigation bar.
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  // int _selectedIndex = 0; // Start with the "Scan" icon selected

  // This is a simple list of widgets to display based on the selected index.
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const PpvScreen(),
    const LiveScreen(),
    const ProfileScreen()

  ];

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        height: 60.0.h,
        items: <Widget>[
          Center(child: Icon(FontAwesomeIcons.homeUser, size: 25.sp, color: AllColor.white)),
          Icon(FontAwesomeIcons.eye,
              size: 25.sp, color: AllColor.white),
          Icon(Icons.live_tv,
              size: 25.sp, color: AllColor.white),
          Icon(CupertinoIcons.profile_circled,
              size: 25.sp, color: AllColor.white),
        ],

        color: AllColor.black, // The color of the navigation bar itself.
        buttonBackgroundColor: AllColor.orange, // Color of the selected button.
        
        backgroundColor: AllColor.white, // Background color of the Scaffold behind the nav bar.
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

// Class to hold all image paths as static final strings.