// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/constants/color_control/theme_color_controller.dart';
import 'package:Oloflix/core/constants/image_control/image_path.dart';
import 'package:Oloflix/core/theme/logic/theme_changer.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:Oloflix/features/deshboard/screen/dashboard_screen.dart';
import 'package:Oloflix/features/home/screens/home_screen.dart';
import 'package:Oloflix/features/profile/screen/profile_screen.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:Oloflix/features/watchlist/screen/my_watchlist_screen.dart';


class CustomHomeTopperSection extends StatelessWidget {
  CustomHomeTopperSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: (){
                context.go(BottomNavBar.routeName);
              },
                child: Image.asset(ImagePath.logo, width: 80.w)),
            Spacer(),
            InkWell(
              onTap: () {
                goToSearch(context);
              },
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: AllColor.red,
                child: Icon(Icons.search, color: ThemeColorController.white),
              ),
            ),
            SizedBox(width: 20.w),
            InkWell(
              onTap: () {
                goToSubscriptionScreen(context);
              },
              child: Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  color: AllColor.amber,
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                ),

                child: Icon(Icons.workspace_premium),
              ),
            ),
            // Crown
            SizedBox(width: 5.w),
            _UserMenu(menuItems: menuItems),

            IconButton(
              icon: Icon(Icons.menu_rounded, color: Colors.white, size: 24.sp),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
            SizedBox(width: 5.w),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  final List<_MenuItem> menuItems = [
    _MenuItem('Dashboard', Icons.storage),
    _MenuItem('Profile', Icons.person),
    _MenuItem('My Watchlist', Icons.list_alt),
    _MenuItem('Logout', Icons.logout),
  ];
  final List<String> items = [
    'Apple',
    'Banana',
    'Mango',
    'Orange',
    'Pineapple',
    'Watermelon',
    'Grapes',
    'Strawberry',
  ];
  void goToSearch(BuildContext context) {
    showSearch(context: context, delegate: CustomSearchDelegate(items));
  }

  void goToSubscriptionScreen(BuildContext context) {
    context.push(SubscriptionPlanScreen.routeName);
  }
}

class _UserMenu extends StatelessWidget {
  final List<_MenuItem> menuItems;

  const _UserMenu({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    final ThemeChanger themeController = Get.put(ThemeChanger());
    return PopupMenuButton<int>(
      icon: Stack(
        children: [
          Icon(Icons.person, size: 24.sp),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: ThemeColorController.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeColorController.white,
                  width: 1.w,
                ),
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (context) => List.generate(
        menuItems.length,
        (index) => PopupMenuItem<int>(
          value: index,
          child: Row(
            children: [
              Icon(
                menuItems[index].icon,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              SizedBox(width: 10.w),
              Text(menuItems[index].title),
            ],
          ),
        ),
      ),
      onSelected: (index) {
        goToNextPage(index, context);
      },
    );
  }

  void goToNextPage(int index, BuildContext context) {
    if (index == 0) {
      context.push(DashboardScreen.routeName);
    } else if (index == 1) {
      context.push(ProfileScreen.routeName);
    } else if (index == 2) {
      context.push(MyWatchlistScreen.routeName);
    } else if (index == 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("LogOut"),
            content: Text("Are you sure you want to LogOut ?"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AllColor.red),
                onPressed: () {
                  context.pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text(" LogOut Done")));
                },
                child: const Text("LogOut"),
              ),
            ],
          );
        },
      );
    }
  }
}

class _MenuItem {
  final String title;
  final IconData icon;

  _MenuItem(this.title, this.icon);
}