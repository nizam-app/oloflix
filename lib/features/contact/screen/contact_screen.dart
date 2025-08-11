import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});
  static final routeName = "/ContactScreen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("ContactScreen "),
      ),
    );
  }
}