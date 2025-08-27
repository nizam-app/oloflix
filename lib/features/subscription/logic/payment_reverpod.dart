// lib/features/subscription/logic/payment_reverpod.dart
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/features/subscription/data/payment_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// ✅ Product IDs (App Store Connect-এর সাথে হুবহু মিলবে)
const kProductIdYearlyLocal = 'oloflix_yearlyplan';
const kProductIdYearlyUSD   = 'oloflix_yearlyplan';
const kProductIdPPV         = 'com.oloflix.premiumsub'; // ← নতুন PPV

/// 👉 তোমার verify API
final kVerifyUrl = AuthAPIController.payment_apple_verify;

final purchaseBusyProvider = StateProvider<bool>((ref) => false);

final iapServiceProvider = Provider<IAPService>((ref) => IAPService.instance);

class IapState {
  final bool available;
  final List<ProductDetails> products;
  const IapState({required this.available, required this.products});
}

final iapControllerProvider =
StateNotifierProvider<IapController, AsyncValue<IapState>>((ref) {
  return IapController(ref);
});

class IapController extends StateNotifier<AsyncValue<IapState>> {
  final Ref ref;
  IapController(this.ref) : super(const AsyncValue.loading()) {
    init();
  }

  Future<void> init() async {
    try {
      final svc = ref.read(iapServiceProvider);
      await svc.init(
        productIds: {kProductIdYearlyLocal, kProductIdYearlyUSD, kProductIdPPV}, // ← PPV যোগ
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

/// 🔁 int ভিত্তিক ম্যাপিং: 0=Local, 1=USD, 2=PPV
String productIdForPlan({required int isInternational}) {
  switch (isInternational) {
    case 1: return kProductIdYearlyUSD;
    case 2: return kProductIdPPV;           // ← PPV
    case 0:
    default: return kProductIdYearlyLocal;
  }
}