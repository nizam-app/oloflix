import 'package:Oloflix/features/delete_account/data/delete_account_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';

import '../screen/delete_account_screen.dart';


final deleteAccountRepositoryProvider =
Provider((ref) => const DeleteAccountRepository());

class DeleteAccountController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> confirmAndDelete() async {
    state = const AsyncLoading();
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('token') ??
          sp.getString('access_token') ??
          sp.getString('api_token');
      if (token == null || token.isEmpty) {
        throw Exception('No auth token found.');
      }

      await ref.read(deleteAccountRepositoryProvider).deleteAccount(
        url: AuthAPIController.account_delete,
        token: token,
      );

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
        () => DeleteAccountController());