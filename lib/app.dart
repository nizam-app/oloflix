import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_jango/routes/app_routes.dart';
import 'bindings/controller_binding.dart';
import 'core/theme/light_dark_theme.dart';
import 'core/utils/translation_text.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 852),
      child: MaterialApp.router(
        theme: themeMood(),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

