import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'delete_account_reverpod.dart';

Future<void> flow(BuildContext context, WidgetRef ref) async {
  final ok = await showDialog<bool>(
    context: context, barrierDismissible: false, useRootNavigator: true,
    builder: (d) => AlertDialog(
      title: const Text('Delete account?'),
      content: const Text('This action is permanent. Proceed?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(d).pop(false), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.of(d).pop(true), child: const Text('Delete')),
      ],
    ),
  );
  if (ok != true) return;

  showDialog(
    context: context, barrierDismissible: false, useRootNavigator: true,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    await ref.read(deleteAccountControllerProvider.notifier).confirmAndDelete();
  } catch (e) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    if (!context.mounted) return;
    await showDialog(
      context: context, useRootNavigator: true,
      builder: (d) => AlertDialog(
        title: const Text('Failed'), content: Text(e.toString()),
        actions: [TextButton(onPressed: () => Navigator.of(d).pop(), child: const Text('OK'))],
      ),
    );
    return;
  }

  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop();

  await showDialog(
    context: context, useRootNavigator: true,
    builder: (d) => AlertDialog(
      title: const Text('Deleted'),
      content: const Text('Your account has been deleted successfully.'),
      actions: [TextButton(onPressed: () => Navigator.of(d).pop(), child: const Text('OK'))],
    ),
  );

  if (!context.mounted) return;
  final r = LoginScreen.routeName;
  r.startsWith('/') ? context.go(r) : context.goNamed(r);
}