// lib/features/subscription/data/payment_data.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';

class IAPService {
  IAPService._();
  static final IAPService instance = IAPService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  bool _available = false;
  bool get isAvailable => _available;

  final Map<String, ProductDetails> _products = {};
  List<ProductDetails> get allProducts => _products.values.toList();

  // Verify URLs - Platform-specific
  String get _verifyUrlSub => Platform.isAndroid 
      ? AuthAPIController.payment_google_verify 
      : AuthAPIController.payment_apple_verify;
  String get _verifyUrlPpv => Platform.isAndroid
      ? AuthAPIController.payment_google_ppv_verify
      : AuthAPIController.payment_apple_ppv_verify;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  Completer<bool>? _pending; // a single in-flight purchase guard

  // UI extra payload (for PPV/subscription)
  Map<String, dynamic> _extraPayload = {};
  void setExtraPayload(Map<String, dynamic> payload) {
    _extraPayload = payload;
    _log('setExtraPayload: $_extraPayload');
  }

  // ------------ Utils -------------
  void _log(String msg) {
    foundation.debugPrint('[IAP] $msg');
  }

  /// StoreKit2 sync if available (safe no-op on older OS)
  Future<void> _storekitSyncIfPossible() async {
    if (!Platform.isIOS) return;
    try {
      final add =
      _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await add.sync(); // StoreKit2 only; plugin handles availability
      _log('StoreKit sync() done ✅');
    } catch (e) {
      _log('StoreKit sync() skipped: $e');
    }
  }

  /// Try to refresh verification data (receipt) from StoreKit.
  /// Returns base64 serverVerificationData if available, else null.
  Future<String?> _refreshVerificationDataIfPossible() async {
    if (!Platform.isIOS) return null;
    try {
      final add =
      _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      final data = await add.refreshPurchaseVerificationData();
      if (data != null) {
        _log('refreshPurchaseVerificationData() -> got data ✅');
        return data.serverVerificationData;
      }
      _log('refreshPurchaseVerificationData() -> null');
    } catch (e) {
      _log('refreshPurchaseVerificationData() failed: $e');
    }
    return null;
  }

  // ------------ Public API -------------

  Future<void> init({
    required Set<String> productIds,
    required String serverVerifyUrl, // backward compatible (deprecated, use platform detection)
  }) async {
    // Note: serverVerifyUrl is kept for backward compatibility but platform detection takes precedence

    _available = await _iap.isAvailable();
    _log('IAP available: $_available');
    if (!_available) return;

    final resp = await _iap.queryProductDetails(productIds);
    _products
      ..clear()
      ..addEntries(resp.productDetails.map((p) => MapEntry(p.id, p)));

    _log('Products loaded: ${_products.keys.toList()}');
    if (resp.notFoundIDs.isNotEmpty) {
      _log('⚠️ notFoundIDs: ${resp.notFoundIDs}');
    }

    await _purchaseSub?.cancel();
    _purchaseSub = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () {
        _log('purchaseStream done');
        _purchaseSub?.cancel();
      },
      onError: (e) => _log('purchaseStream error: $e'),
    );
  }

  /// PPV => buyConsumable(autoConsume: true), otherwise non-consumable
  Future<bool> buy(String productId) async {
    if (!_available) {
      _log('buy failed: store not available');
      return false;
    }
    if (_pending != null && !(_pending!.isCompleted)) {
      _log('buy blocked: another purchase pending');
      return false;
    }

    final product = _products[productId];
    if (product == null) {
      _log('buy failed: Product not found: $productId');
      throw Exception('Product not found: $productId');
    }

    final isPpv = (_extraPayload['source']?.toString() == 'ppv');
    _log('buy start → productId=$productId, isPpv=$isPpv, payload=$_extraPayload');

    _pending = Completer<bool>();
    final param = PurchaseParam(productDetails: product);

    try {
      if (isPpv) {
        await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
      } else {
        await _iap.buyNonConsumable(purchaseParam: param);
      }
    } on Exception catch (e) {
      // cancel/error হলে stream না এলেও pending release হবে
      foundation.debugPrint('[IAP] buy exception: $e');
      if (!(_pending?.isCompleted ?? true)) _pending?.complete(false);
      _pending = null;
      return false;
    }

    return _pending!.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        _log('buy timeout');
        if (!(_pending?.isCompleted ?? true)) _pending?.complete(false);
        return false;
      },
    );
  }

  Future<void> restore() async {
    _log('restorePurchases called');
    await _iap.restorePurchases();
  }

  Future<void> _finish(PurchaseDetails p) async {
    _log('completePurchase: ${p.purchaseID} (pending=${p.pendingCompletePurchase})');
    await _iap.completePurchase(p);
  }

  // ------------ Stream Handler -------------

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> list) async {
    for (final p in list) {
      _log('onPurchaseUpdated: status=${p.status} id=${p.purchaseID} '
          'pending=${p.pendingCompletePurchase} product=${p.productID}');
      try {
        if (p.status == PurchaseStatus.purchased ||
            p.status == PurchaseStatus.restored) {
          // 1) Optional sync (StoreKit2)
          await _storekitSyncIfPossible();

          // 2) Pick verification data based on platform
          String? purchaseToken;
          String? receiptData;
          
          if (Platform.isAndroid) {
            // Android/Google: Extract purchase token from verification data
            // The purchase token is typically in serverVerificationData for Android
            purchaseToken = p.verificationData.serverVerificationData;
            if (purchaseToken.isEmpty) {
              // Try to get from source if available
              purchaseToken = p.verificationData.source;
            }
            _log('Android purchase token extracted: ${purchaseToken.isNotEmpty ? purchaseToken.substring(0, purchaseToken.length > 20 ? 20 : purchaseToken.length) + "..." : "empty"}');
          } else {
            // iOS/Apple: Use receipt data
            receiptData = p.verificationData.serverVerificationData;
            if (receiptData.isEmpty) {
              _log('serverVerificationData empty → trying refreshPurchaseVerificationData()');
              final refreshed = await _refreshVerificationDataIfPossible();
              if (refreshed != null && refreshed.isNotEmpty) {
                receiptData = refreshed;
              }
            }
          }

          final ok = await _verifyOnServer(
            purchaseToken: purchaseToken,
            receiptData: receiptData,
            transactionId: p.purchaseID,
            productId: p.productID,
          );

          if (!(_pending?.isCompleted ?? true)) {
            _pending?.complete(ok);
          }

          if (p.pendingCompletePurchase) {
            await _finish(p);
          }
        } else if (p.status == PurchaseStatus.error ||
            p.status == PurchaseStatus.canceled) {
          _log('purchase ${p.status}');
          if (!(_pending?.isCompleted ?? true)) {
            _pending?.complete(false);
          }
          if (p.pendingCompletePurchase) {
            await _finish(p);
          }
        } else if (p.status == PurchaseStatus.pending) {
          _log('purchase pending…');
        }
      } catch (e) {
        _log('onPurchaseUpdated error: $e');
        if (!(_pending?.isCompleted ?? true)) _pending?.complete(false);
        if (p.pendingCompletePurchase) {
          await _finish(p);
        }
      } finally {
        _extraPayload = {};
        _pending = null;
      }
    }
  }

  // ------------ Server Verify (POST) -------------

  /// Platform-aware verification:
  /// Android/Google: {purchase_token, product_id, plan_id}
  /// iOS/Apple: {receipt, plan_id} (existing format)
  /// ppv: {receipt/purchase_token, movie_id, transaction_id, days}
  Future<bool> _verifyOnServer({
    String? purchaseToken,
    String? receiptData,
    required String? transactionId,
    required String? productId,
  }) async {
    try {
      // auth header (Laravel API হলে দরকার)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final isPpv = (_extraPayload['source']?.toString() == 'ppv');
      final uri = Uri.parse(isPpv ? _verifyUrlPpv : _verifyUrlSub);

      late final Map<String, dynamic> body;
      
      if (Platform.isAndroid) {
        // Android/Google verification format
        if (isPpv) {
          // PPV for Android - API spec: {purchase_token, product_id, movie_id}
          body = {
            'purchase_token': purchaseToken ?? '',
            'product_id': productId ?? '',
            'movie_id': _extraPayload['movieId'],
          };
        } else {
          // Subscription for Android/Google
          body = {
            'purchase_token': purchaseToken ?? '',
            'product_id': productId ?? '',
            'plan_id': _extraPayload['planId'],
          };
        }
      } else {
        // iOS/Apple verification format (existing)
        if (isPpv) {
          body = {
            'receipt': receiptData ?? '',
            'movie_id': _extraPayload['movieId'],
            'transaction_id': transactionId,
            'days': _extraPayload['days'] ?? 3,
          };
        } else {
          body = {
            'receipt': receiptData ?? '',
            'plan_id': _extraPayload['planId'],
          };
        }
      }

      // 🔎 LOG (mask sensitive data)
      foundation.debugPrint('verify POST → $uri (Platform: ${Platform.isAndroid ? "Android" : "iOS"})');
      final maskedBody = Map<String, dynamic>.from(body);
      if (maskedBody.containsKey('purchase_token')) {
        maskedBody['purchase_token'] = '***masked***';
      }
      if (maskedBody.containsKey('receipt')) {
        maskedBody['receipt'] = '***masked***';
      }
      foundation.debugPrint('payload: ${jsonEncode(maskedBody)}');

      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      foundation.debugPrint('status: ${res.statusCode} body: ${res.body}');
      if (res.statusCode != 200) {
        _log('verify failed: HTTP ${res.statusCode}');
        return false;
      }

      final data = jsonDecode(res.body);
      final success =
          (data['status'] == 'success') || (data['active'] == true);
      _log('server verify (POST) → success=$success');
      
      // Store PPV order_id and expiry_date for Android only
      if (success && Platform.isAndroid && isPpv && data['data'] != null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final ppvData = data['data'] as Map<String, dynamic>;
          final orderId = ppvData['order_id']?.toString();
          final expiryDate = ppvData['expiry_date']?.toString();
          
          if (orderId != null) {
            await prefs.setString('ppv_order_id_${_extraPayload['movieId']}', orderId);
            _log('Stored PPV order_id: $orderId');
          }
          if (expiryDate != null) {
            await prefs.setString('ppv_expiry_${_extraPayload['movieId']}', expiryDate);
            _log('Stored PPV expiry_date: $expiryDate');
          }
        } catch (e) {
          _log('Error storing PPV data: $e');
        }
      }
      
      return success;
    } catch (e) {
      _log('verify (POST) error: $e');
      return false;
    }
  }

  void dispose() {
    _purchaseSub?.cancel();
  }
}