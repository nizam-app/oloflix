// lib/features/subscription/logic/plans_provider.dart
import 'package:Oloflix/features/subscription/data/plan_data.dart';
import 'package:Oloflix/features/subscription/model/plan_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plansProvider = FutureProvider<List<Plan>>((ref) async {
  return PlansRepository.fetchPlans();
});