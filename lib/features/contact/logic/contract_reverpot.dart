
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/features/contact/data/contact_data.dart'; // ContactRepository

final contactRepositoryProvider = Provider((_) => const ContactRepository());

final contactControllerProvider =
AsyncNotifierProvider<ContactController, void>(ContactController.new);

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
    await ref.read(contactRepositoryProvider).send(
      url: AuthAPIController.contact,
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'subject': subject.trim(),
        'message': message.trim(),
      },
    );
  }
}