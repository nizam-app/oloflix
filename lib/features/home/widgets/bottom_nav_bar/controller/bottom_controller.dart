import 'package:get/get.dart';
import 'package:market_jango/features/home/screens/home_screen.dart';
import 'package:market_jango/features/live/screen/live_screen.dart';
import 'package:market_jango/features/ppv/screen/ppv_screen.dart';
import 'package:market_jango/features/profile/screen/profile_screen.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final pages = [HomeScreen(), PpvScreen(), LiveScreen(), ProfileScreen()];
}
