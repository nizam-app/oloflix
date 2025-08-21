import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

void goToPPvScreen(WidgetRef ref,) {
  ref.read(selectedIndexProvider.notifier).state = 1;
}