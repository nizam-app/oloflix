// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:market_jango/routes/app_routes.dart';
import 'core/theme/light_dark_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: themeMood(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
