import 'package:flutter/material.dart';

class MusicVideoScreen extends StatelessWidget {
  const MusicVideoScreen({super.key});
  static final routeName = "/musicVideoScreen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("MusicVideoScreen"),
      ),
    );
  }
}