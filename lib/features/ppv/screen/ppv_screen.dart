import 'package:flutter/material.dart';

class PpvScreen extends StatelessWidget {
  const PpvScreen({super.key});
  static final routeName = "/ppv_screen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("PPv Screen"),
      ),
    );
  }
}