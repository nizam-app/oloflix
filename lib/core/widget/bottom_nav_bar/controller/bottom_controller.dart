import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/deshboard/logic/deshboard_reverport.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

void goToPPvScreen(WidgetRef ref,) {
  ref.read(selectedIndexProvider.notifier).state = 1;


}
const Set<int> premiumPlanIds = {8, 12};

bool hasPremium(WidgetRef ref) {
  final user = ref.read(userProvider);
  final planId = user?.planId;
  return planId != null && premiumPlanIds.contains(planId);
}