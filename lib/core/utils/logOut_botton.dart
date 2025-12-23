import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text("LogOut"),
        content: Text("Are you sure you want to LogOut ?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AllColor.red),
            onPressed: () async {
              await logout(ctx); // তোমার আগের logout() একই আছে
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text(" LogOut Done")),
              );
            },
            child: const Text("LogOut"),
          ),
        ],
      );
    },
  );
}
Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  // সব ডেটা clear করো
  await prefs.clear();

  // login screen এ redirect করো
  context.go(LoginScreen.routeName);
}