// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:market_jango/core/theme/text_theme.dart';
import '../constants/color_control/theme_color_controller.dart';
import 'elevated_button_theme.dart';
import 'input_decoration_theme.dart';
import 'logic/theme_changer.dart';

final ThemeChanger _themeController = Get.put(ThemeChanger());
ThemeData themeMood() {
  Brightness brightness = _themeController.isDarkMode.value
      ? Brightness.light
      : Brightness.dark;
  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.light(
      brightness: brightness,
      primary: _themeController.isDarkMode.value
          ? ThemeColorController.white
          : ThemeColorController.black,
      onPrimary: _themeController.isDarkMode.value
          ? ThemeColorController.black
          : ThemeColorController.white,
      secondary: _themeController.isDarkMode.value
          ? ThemeColorController.white
          : ThemeColorController.black,
      onSecondary: _themeController.isDarkMode.value
          ? ThemeColorController.black
          : ThemeColorController.white,
      surface: _themeController.isDarkMode.value
          ? ThemeColorController.white
          : ThemeColorController.black,
      onSurface: _themeController.isDarkMode.value
          ? ThemeColorController.black
          : ThemeColorController.white,
    ),
    inputDecorationTheme: inputDecorationTheme,
    useMaterial3: true,
    scaffoldBackgroundColor: _themeController.isDarkMode.value
        ? ThemeColorController.white
        : ThemeColorController.black,
    textTheme: textTheme,
    elevatedButtonTheme: elevatedButtonTheme(),
  );
}
