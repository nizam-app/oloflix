import 'package:Oloflix/features/ppv/screen/ppv_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/deshboard/logic/deshboard_reverport.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

void goToPPvScreen(WidgetRef ref,BuildContext context) {
  context.push(PpvScreen.routeName);



}
const Set<int> premiumPlanIds = {8, 12};

bool hasPremium(WidgetRef ref) {
  final user = ref.read(userProvider);
  final planId = user?.planId;
  return planId != null && premiumPlanIds.contains(planId);
}