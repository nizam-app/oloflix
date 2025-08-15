// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:market_jango/core/widget/bottom_nav_bar/controller/bottom_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});
  static const String routeName = '/bottom_nav_bar';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());

    return Obx(
      () => Scaffold(
        body: controller.pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.yellow.shade500,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye),
              label: "PPV",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_camera_back),
              label: "Live ",
            ),

            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
