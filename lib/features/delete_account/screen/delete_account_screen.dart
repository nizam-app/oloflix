import 'package:Oloflix/features/delete_account/logic/delete_account_reverpod.dart';
import 'package:Oloflix/features/delete_account/logic/delete_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:Oloflix/features/auth/screens/login_screen.dart';

import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});
  static const routeName = "/DeleteAccountScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              const AbouteBackgrountImage(screenName: "Delete Account"),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    _Title(), SizedBox(height: 20),
                    _Sub(), SizedBox(height: 20),
                    _Note(), SizedBox(height: 30),
                    _DeleteBtn(), SizedBox(height: 20),
                    _AltNote(),
                  ],
                ),
              ),
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});
  @override
  Widget build(BuildContext context) => const Text(
    "We're Sad to See You Go!!!",
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
    textAlign: TextAlign.center,
  );
}

class _Sub extends StatelessWidget {
  const _Sub({super.key});
  @override
  Widget build(BuildContext context) => const Text(
    "Are you not satisfied using Oloflix?",
    style: TextStyle(fontSize: 18, color: Colors.grey),
    textAlign: TextAlign.center,
  );
}

class _Note extends StatelessWidget {
  const _Note({super.key});
  @override
  Widget build(BuildContext context) => const Text(
    "We wish to have you stay. BUT you are free to request Account Deletion Anytime.",
    style: TextStyle(fontSize: 16),
    textAlign: TextAlign.center,
  );
}

class _DeleteBtn extends ConsumerWidget {
  const _DeleteBtn({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red, foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    ),
    onPressed: () => flow(context, ref),
    child: const Text("DELETE MY ACCOUNT",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}

class _AltNote extends StatelessWidget {
  const _AltNote({super.key});
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      Text('Optionally, you can also use the "DELETE ACCOUNT" button',
          style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
      Text("under your profile photo while logged into your dashboard.",
          style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
    ],
  );
}