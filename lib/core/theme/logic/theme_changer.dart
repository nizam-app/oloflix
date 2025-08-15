// Package imports:
import 'package:get/get.dart';

class ThemeChanger extends GetxController {
  RxBool isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    update();
  }
}
