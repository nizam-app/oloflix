import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/features/subscription/data/payment_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// ✅ Product IDs (App Store Connect-এর সাথে হুবহু মিলবে)
const kProductIdYearlyLocal = 'com.oloflix.premium.yearly.local';
const kProductIdYearlyUSD   = 'com.oloflix.premium.yearly.usd';

/// 👉 তোমার verify API (Node/Laravel যেটা বানাবে)
final kVerifyUrl = AuthAPIController.payment_apple_verify;

/// UI-তে লোডিং/ডিসেবল করার জন্য
final purchaseBusyProvider = StateProvider<bool>((ref) => false);

/// IAP সার্ভিস ইনস্ট্যান্স
final iapServiceProvider = Provider<IAPService>((ref) => IAPService.instance);

/// প্রোডাক্ট লোড/অ্যাভেইলেবিলিটির স্টেট
class IapState {
  final bool available;
  final List<ProductDetails> products;
  const IapState({required this.available, required this.products});
}

/// Controller: init(), buy(), restore()
final iapControllerProvider =
StateNotifierProvider<IapController, AsyncValue<IapState>>((ref) {
  return IapController(ref);
});

class IapController extends StateNotifier<AsyncValue<IapState>> {
  final Ref ref;
  IapController(this.ref) : super(const AsyncValue.loading()) {
    init(); // তৈরি হলেই init করে দিচ্ছি
  }

  Future<void> init() async {
    try {
      final svc = ref.read(iapServiceProvider);
      await svc.init(
        productIds: {kProductIdYearlyLocal, kProductIdYearlyUSD},
        serverVerifyUrl: kVerifyUrl,
      );
      state = AsyncValue.data(
        IapState(
          available: svc.isAvailable,
          products: svc.allProducts,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> buy(String productId) async {
    final svc = ref.read(iapServiceProvider);
    ref.read(purchaseBusyProvider.notifier).state = true;
    try {
      final ok = await svc.buy(productId);
      return ok;
    } finally {
      ref.read(purchaseBusyProvider.notifier).state = false;
    }
  }

  Future<void> restore() async {
    final svc = ref.read(iapServiceProvider);
    await svc.restore();
  }
}

/// তোমার UI থেকে plan → productId ম্যাপ
String productIdForPlan({required bool isInternational}) {
  return isInternational ? kProductIdYearlyUSD : kProductIdYearlyLocal;
}