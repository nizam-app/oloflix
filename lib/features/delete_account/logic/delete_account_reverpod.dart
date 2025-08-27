// lib/features/profile/logic/delete_account_controller.dart
import 'package:Oloflix/features/delete_account/data/delete_account_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/screens/login_screen.dart'; // routeName ব্যবহার করলে দরকার হবে
import 'package:Oloflix/core/constants/api_control/auth_api.dart'; // AuthApi.deleteAccount

final deleteAccountRepositoryProvider =
Provider<DeleteAccountRepository>((ref) => const DeleteAccountRepository());

class DeleteAccountController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> confirmAndDelete() async {
    state = const AsyncLoading();

    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('token');
      if (token == null || token.isEmpty) {
        throw Exception('No auth token found.');
      }

      final repo = ref.read(deleteAccountRepositoryProvider);
      await repo.deleteAccount(
        url: AuthAPIController.account_delete, // <-- তোমার কনস্ট্যান্ট/URL
        token: token,
      );

      // লোকাল ডেটা ক্লিয়ার
      await sp.clear();

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final deleteAccountControllerProvider =
AsyncNotifierProvider<DeleteAccountController, void>(
      () => DeleteAccountController(),
);