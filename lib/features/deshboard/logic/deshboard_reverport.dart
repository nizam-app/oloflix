import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/features/deshboard/data/deshboard_data.dart';
import 'package:Oloflix/features/deshboard/model/deshboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API base/url আলাদা রাখলে manage করা সহজ হয়
final profileApiUrlProvider = Provider<String>((ref) {
  return "${AuthAPIController.dashboard}";
});

/// Repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

/// Profile fetcher as FutureProvider
final profileProvider = FutureProvider<ProfileResponse>((ref) async {
  final repo = ref.read(profileRepositoryProvider);
  final url = ref.watch(profileApiUrlProvider);
  return repo.fetchProfile(url);
});

/// শুধু User দরকার হলে
final userProvider = Provider<User?>((ref) {
  final asyncProfile = ref.watch(profileProvider);
  return asyncProfile.maybeWhen(
    data: (data) => data.user,
    orElse: () => null,
  );
});

/// শুধু Transactions দরকার হলে
final transactionsProvider = Provider<List<Transaction>>((ref) {
  final asyncProfile = ref.watch(profileProvider);
  return asyncProfile.maybeWhen(
    data: (data) => data.transactions,
    orElse: () => const [],
  );
});