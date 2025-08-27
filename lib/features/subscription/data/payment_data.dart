// lib/features/subscription/data/payment_data.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';

class IAPService {
  IAPService._();
  static final IAPService instance = IAPService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  bool _available = false;
  bool get isAvailable => _available;

  final Map<String, ProductDetails> _products = {};
  List<ProductDetails> get allProducts => _products.values.toList();

  // দুইটা URL আলাদা করে নেই
  String _verifyUrlSub = AuthAPIController.payment_apple_verify;
  String _verifyUrlPpv = AuthAPIController.payment_apple_ppv_verify;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  Completer<bool>? _pending;

  /// UI থেকে সেট করা extra payload (PPV হলে movieId, days ইত্যাদি)
  Map<String, dynamic> _extraPayload = {};
  void setExtraPayload(Map<String, dynamic> payload) {
    _extraPayload = payload;
  }

  Future<void> init({
    required Set<String> productIds,
    required String serverVerifyUrl, // আগের প্যারামটা রেখে দিচ্ছি, কিন্তু সাবস্ক্রিপশনে ব্যবহার করব
  }) async {
    // backward compatible
    _verifyUrlSub = serverVerifyUrl.isNotEmpty ? serverVerifyUrl : _verifyUrlSub;

    _available = await _iap.isAvailable();
    if (!_available) return;

    final resp = await _iap.queryProductDetails(productIds);
    _products
      ..clear()
      ..addEntries(resp.productDetails.map((p) => MapEntry(p.id, p)));

    await _purchaseSub?.cancel();
    _purchaseSub = _iap.purchaseStream.listen(_onPurchaseUpdated, onDone: () {
      _purchaseSub?.cancel();
    });
  }

  Future<bool> buy(String productId) async {
    if (!_available) return false;
    final product = _products[productId];
    if (product == null) throw Exception('Product not found: $productId');

    _pending = Completer<bool>();
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
    return _pending!.future;
  }

  Future<void> restore() => _iap.restorePurchases();
  Future<void> _finish(PurchaseDetails p) => _iap.completePurchase(p);

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> list) async {
    for (final p in list) {
      if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
        final ok = await _verifyOnServer(
          receiptData: p.verificationData.serverVerificationData,
          transactionId: p.purchaseID,
        );
        if (ok) {
          await _finish(p);
          _pending?.complete(true);
        } else {
          _pending?.complete(false);
        }
        _pending = null;
        _extraPayload = {};
      } else if (p.status == PurchaseStatus.error || p.status == PurchaseStatus.canceled) {
        _pending?.complete(false);
        _pending = null;
        _extraPayload = {};
      }
    }
  }

  /// ✅ এখানে দুই ধরনের body/URL পাঠানো হচ্ছে:
  /// - subscription: {receipt, plan_id}
  /// - ppv:          {receipt, movie_id, transaction_id, days}
  Future<bool> _verifyOnServer({
    required String receiptData,
    required String? transactionId,
  }) async {
    try {
      final isPpv = (_extraPayload['source']?.toString() == 'ppv');

      final uri = Uri.parse(isPpv ? _verifyUrlPpv : _verifyUrlSub);
      Map<String, dynamic> body;

      if (isPpv) {
        body = {
          'receipt': receiptData,
          'movie_id': _extraPayload['movieId'],     // int
          'transaction_id': transactionId,          // string
          'days': _extraPayload['days'] ?? 3,       // int (default 3)
        };
      } else {
        body = {
          'receipt': receiptData,
          'plan_id': _extraPayload['planId'],       // int (UI থেকে পাঠাবো)
        };
      }

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode != 200) return false;
      final data = jsonDecode(res.body);
      // তোমাদের ব্যাকএন্ড true/active/status==success যেটাই দিক, সে অনুসারে চেক করো
      return (data['status'] == 'success') || (data['active'] == true);
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _purchaseSub?.cancel();
  }
}