import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/features/profile/data/data%20get.dart';
import 'package:Oloflix/features/profile/data/profile_data_update.dart';
import 'package:Oloflix/features/profile/model/profile_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDataController{ // Repository Provider
static final profileRepositoryProvider = Provider((ref) => ProfileRepository());

// FutureProvider for Profile
static final profileProvider = FutureProvider<ProfileResponse>((ref) async {
  final repo = ref.read(profileRepositoryProvider);
  return repo.fetchProfile(AuthAPIController.profile);
});

// features/profile/logic/profile_data_controller.dart
// features/profile/logic/profile_data_controller.dart
  static final profileUpdateController =
  StateNotifierProvider<ProfileUpdateController, AsyncValue<void>>(
        (ref) => ProfileUpdateController(),
  );




}