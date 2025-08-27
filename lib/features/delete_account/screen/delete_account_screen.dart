// lib/features/profile/ui/delete_account_screen.dart
import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:Oloflix/features/delete_account/logic/delete_account_reverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:go_router/go_router.dart';
// <-- helper import

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
              const AbouteBackgrountImage(screenName: "Delete Account"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    _GoodbyeMessage(),
                    SizedBox(height: 20),
                    _SatisfactionQuestion(),
                    SizedBox(height: 20),
                    _StayRequestMessage(),
                    SizedBox(height: 30),
                    _DeleteAccountButton(),   // <-- updated (ConsumerWidget)
                    SizedBox(height: 20),
                    _AlternativeMethodInstructions(),
                  ],
                ),
              ),
              FooterSection()
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- Custom Codebase -----------------

class _GoodbyeMessage extends StatelessWidget {
  const _GoodbyeMessage({super.key});
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
  const _SatisfactionQuestion({super.key});
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
  const _StayRequestMessage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text(
      "We wish to have you stay. BUT you are free to request Account Deletion Anytime.",
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }
}

/// ⬇️ Button now uses Riverpod + shows dialog flow
class _DeleteAccountButton extends ConsumerWidget {
  const _DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: () => showDeleteAccountFlow(context, ref),
      child: const Text(
        "DELETE MY ACCOUNT",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AlternativeMethodInstructions extends StatelessWidget {
  const _AlternativeMethodInstructions({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Optionally, you can also use the \"DELETE ACCOUNT\" button",
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        Text(
          "under your profile photo while logged into your dashboard.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

Future<void> showDeleteAccountFlow(BuildContext context, WidgetRef ref) async {
  // 1) Confirm
  final ok = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Delete account?'),
      content: const Text(
          'This action is permanent. Do you really want to delete your account?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
      ],
    ),
  );

  if (ok != true) return;

  // 2) Progress
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    await ref.read(deleteAccountControllerProvider.notifier).confirmAndDelete();

    // progress বন্ধ
    Navigator.of(context).pop();

    // 3) Success
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deleted'),
        content: const Text('Your profile has been deleted successfully.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );

    if (context.mounted) context.go(LoginScreen.routeName);
  } catch (e) {
    // progress বন্ধ
    Navigator.of(context).pop();

    // 4) Error
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Failed'),
        content: Text(e.toString()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}