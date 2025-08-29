import 'package:Oloflix/features/contact/data/contact_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';

final contactRepositoryProvider = Provider((ref) => const ContactRepository());

class ContactController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    state = const AsyncLoading();
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('token') ;

      final headers = {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      await ref.read(contactRepositoryProvider).send(
        url: AuthAPIController.contact, // <-- তোমার contact API endpoint
        headers: headers,
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'subject': subject.trim(),
          'message': message.trim(),
        },
      );

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final contactControllerProvider =
AsyncNotifierProvider<ContactController, void>(ContactController.new);