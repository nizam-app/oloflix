import 'package:flutter/material.dart';
import 'package:market_jango/core/widget/aboute_backgrount_image.dart';
import 'package:market_jango/core/widget/aboute_fooder.dart';
import 'package:market_jango/core/widget/custom_home_topper_section.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});
  static final routeName = "/DeleteAccountScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    CustomHomeTopperSection(),
                const AbouteBackgrountImage(screenName: "Delete Account"
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _GoodbyeMessage(),
                      const SizedBox(height: 20),
                      _SatisfactionQuestion(),
                      const SizedBox(height: 20),
                      _StayRequestMessage(),
                      const SizedBox(height: 30),
                      _DeleteAccountButton(),
                      const SizedBox(height: 20),
                      _AlternativeMethodInstructions(),
                    ],
                  ),
                ) ,
                FooterSection()
            ])
    )
    ));
  }
}

// Custom Codebase



class _GoodbyeMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "We're Sad to See You Go!!!",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _SatisfactionQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "Are you not satisfied using Oloflix?",
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _StayRequestMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "We wish to have you stay. BUT you are free to request Account Deletion Anytime.",
      style: TextStyle(
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: () {
        // Add account deletion logic here
      },
      child: const Text(
        "DELETE MY ACCOUNT",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AlternativeMethodInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Optionally, you can also use the \"DELETE ACCOUNT\" button",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "under your profile photo while logged into your dashboard.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}