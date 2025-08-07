import 'package:flutter/material.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});
  static final routeName = "/live_screen"; 

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("Live Screen"),
      ),
    );
  }
}