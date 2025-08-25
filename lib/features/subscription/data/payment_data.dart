import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  IAPService._();
  static final IAPService instance = IAPService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  bool _available = false;
  bool get isAvailable => _available;

  final Map<String, ProductDetails> _products = {};
  List<ProductDetails> get allProducts => _products.values.toList();

  String _verifyUrl = '';
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  Completer<bool>? _pending;

  /// একবার init করলে স্ট্রীম সেট হয়ে যাবে
  Future<void> init({
    required Set<String> productIds,
    required String serverVerifyUrl,
  }) async {
    _verifyUrl = serverVerifyUrl;

    _available = await _iap.isAvailable();
    if (!_available) return;

    final resp = await _iap.queryProductDetails(productIds);
    _products.clear();
    for (final p in resp.productDetails) {
      _products[p.id] = p;
    }

    // purchase stream listen
    await _purchaseSub?.cancel();
    _purchaseSub = _iap.purchaseStream.listen(_onPurchaseUpdated, onDone: () {
      _purchaseSub?.cancel();
    });
  }

  /// productId দিয়ে সাবস্ক্রিপশন কিনবে
  Future<bool> buy(String productId) async {
    if (!_available) return false;
    final product = _products[productId];
    if (product == null) {
      throw Exception('Product not found: $productId');
    }

    _pending = Completer<bool>();
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param); // auto-renewable sub trigger

    return _pending!.future; // result purchase stream থেকে resolve হবে
  }

  Future<void> restore() => _iap.restorePurchases();

  Future<void> _finish(PurchaseDetails p) => _iap.completePurchase(p);

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> list) async {
    for (final p in list) {
      if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
        final ok = await _verifyOnServer(
          receiptData: p.verificationData.serverVerificationData,
          productId: p.productID,
          transactionId: p.purchaseID,
        );
        if (ok) {
          await _finish(p);
          _pending?.complete(true);
        } else {
          _pending?.complete(false);
        }
        _pending = null;
      } else if (p.status == PurchaseStatus.error || p.status == PurchaseStatus.canceled) {
        _pending?.complete(false);
        _pending = null;
      }
    }
  }

  /// তোমার Backend এ verify-receipt কল
  Future<bool> _verifyOnServer({
    required String receiptData,
    required String productId,
    required String? transactionId,
  }) async {
    if (_verifyUrl.isEmpty) return false;
    try {
      final res = await http.post(
        Uri.parse(_verifyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'platform': 'ios',
          'receiptData': receiptData,
          'productId': productId,
          'transactionId': transactionId,
        }),
      );
      if (res.statusCode != 200) return false;
      final data = jsonDecode(res.body);
      return data['active'] == true;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _purchaseSub?.cancel();
  }
}