// lib/features/subscription/data/flutterwave_payment_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';

/// Flutterwave payment service for Android
class FlutterwavePaymentService {
  FlutterwavePaymentService._();
  static final FlutterwavePaymentService instance = FlutterwavePaymentService._();

  // Store tx_ref from payment initiation for fallback
  String? _lastTxRef;

  void _log(String msg) {
    debugPrint('[Flutterwave] $msg');
  }

  /// Get the last transaction reference (for fallback)
  String? get lastTxRef => _lastTxRef;

  /// Initiate subscription payment with Flutterwave
  /// 
  /// [planId] - The subscription plan ID
  /// [amount] - The payment amount (optional, can be retrieved from plan)
  /// 
  /// Returns the payment URL or null if failed
  Future<String?> initiateSubscriptionPayment({
    required int planId,
    String? amount,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final uri = Uri.parse(AuthAPIController.payment_flutterwave_initiate);

      final body = <String, dynamic>{
        'plan_id': planId,
      };
      if (amount != null && amount.isNotEmpty) {
        body['amount'] = amount;
      }

      _log('Initiating subscription payment...');
      _log('Plan ID: $planId');
      _log('Endpoint: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('Request timeout');
          throw Exception('Request timeout');
        },
      );

      _log('Response status: ${response.statusCode}');
      _log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'success' && data['data'] != null) {
          final paymentData = data['data'] as Map<String, dynamic>;
          final paymentUrl = paymentData['payment_url']?.toString() ?? 
                            paymentData['link']?.toString() ??
                            paymentData['url']?.toString();
          
          if (paymentUrl != null && paymentUrl.isNotEmpty) {
            _log('✅ Payment URL generated: $paymentUrl');
            // Store tx_ref for potential fallback use
            if (paymentData['tx_ref'] != null) {
              _lastTxRef = paymentData['tx_ref'].toString();
              _log('Transaction reference stored: $_lastTxRef');
            }
            return paymentUrl;
          } else {
            _log('❌ Payment URL is null or empty in response data');
          }
        } else {
          _log('❌ Response status is not success or data is null');
          if (data['message'] != null) {
            _log('Response message: ${data['message']}');
          }
        }
        _log('❌ Payment URL not found in response');
        return null;
      } else {
        _log('❌ HTTP error: ${response.statusCode}');
        try {
          final errorData = jsonDecode(response.body);
          _log('Error message: ${errorData['message'] ?? 'Unknown error'}');
        } catch (_) {
          _log('Error response: ${response.body}');
        }
        return null;
      }
    } catch (e, stackTrace) {
      _log('❌ Exception during payment initiation: $e');
      _log('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Initiate PPV payment with Flutterwave
  /// 
  /// [movieId] - The movie ID for PPV purchase
  /// [amount] - The payment amount (optional)
  /// 
  /// Returns the payment URL or null if failed
  Future<String?> initiatePPVPayment({
    required int movieId,
    String? amount,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final uri = Uri.parse(AuthAPIController.payment_flutterwave_ppv_initiate);

      final body = <String, dynamic>{
        'movie_id': movieId,
      };
      if (amount != null && amount.isNotEmpty) {
        body['amount'] = amount;
      }

      _log('Initiating PPV payment...');
      _log('Movie ID: $movieId');
      _log('Endpoint: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('Request timeout');
          throw Exception('Request timeout');
        },
      );

      _log('Response status: ${response.statusCode}');
      _log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'success' && data['data'] != null) {
          final paymentData = data['data'] as Map<String, dynamic>;
          final paymentUrl = paymentData['payment_url']?.toString() ?? 
                            paymentData['link']?.toString() ??
                            paymentData['url']?.toString();
          
          if (paymentUrl != null && paymentUrl.isNotEmpty) {
            _log('✅ Payment URL generated: $paymentUrl');
            // Store tx_ref for potential fallback use
            if (paymentData['tx_ref'] != null) {
              _lastTxRef = paymentData['tx_ref'].toString();
              _log('Transaction reference stored: $_lastTxRef');
            }
            return paymentUrl;
          } else {
            _log('❌ Payment URL is null or empty in response data');
          }
        } else {
          _log('❌ Response status is not success or data is null');
          if (data['message'] != null) {
            _log('Response message: ${data['message']}');
          }
        }
        _log('❌ Payment URL not found in response');
        return null;
      } else {
        _log('❌ HTTP error: ${response.statusCode}');
        try {
          final errorData = jsonDecode(response.body);
          _log('Error message: ${errorData['message'] ?? 'Unknown error'}');
        } catch (_) {
          _log('Error response: ${response.body}');
        }
        return null;
      }
    } catch (e, stackTrace) {
      _log('❌ Exception during payment initiation: $e');
      _log('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Verify subscription payment with Flutterwave
  /// 
  /// [transactionId] - The Flutterwave transaction ID (e.g., "FLW-1234567890")
  /// [planId] - The subscription plan ID
  /// 
  /// Returns true if verification is successful, false otherwise
  Future<bool> verifySubscription({
    required String transactionId,
    required int planId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final uri = Uri.parse(AuthAPIController.payment_flutterwave_verify);

      final body = {
        'transaction_id': transactionId,
        'plan_id': planId,
      };

      _log('Verifying subscription payment...');
      _log('Transaction ID: $transactionId');
      _log('Plan ID: $planId');
      _log('Endpoint: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('Request timeout');
          throw Exception('Request timeout');
        },
      );

      _log('Response status: ${response.statusCode}');
      _log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final success = data['status'] == 'success';
        
        if (success) {
          _log('✅ Subscription payment verified successfully');
          if (data['data'] != null) {
            final paymentData = data['data'] as Map<String, dynamic>;
            _log('Amount: ${paymentData['amount']}');
            _log('Currency: ${paymentData['currency']}');
          }
        } else {
          _log('❌ Verification failed: ${data['message'] ?? 'Unknown error'}');
        }
        
        return success;
      } else {
        _log('❌ HTTP error: ${response.statusCode}');
        try {
          final errorData = jsonDecode(response.body);
          _log('Error message: ${errorData['message'] ?? 'Unknown error'}');
        } catch (_) {
          _log('Error response: ${response.body}');
        }
        return false;
      }
    } catch (e, stackTrace) {
      _log('❌ Exception during verification: $e');
      _log('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Verify PPV (Pay Per View) payment with Flutterwave
  /// 
  /// [transactionId] - The Flutterwave transaction ID (e.g., "FLW-1234567890")
  /// [movieId] - The movie ID for PPV purchase
  /// 
  /// Returns true if verification is successful, false otherwise
  Future<bool> verifyPPV({
    required String transactionId,
    required int movieId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final uri = Uri.parse(AuthAPIController.payment_flutterwave_ppv_verify);

      final body = {
        'transaction_id': transactionId,
        'movie_id': movieId,
      };

      _log('Verifying PPV payment...');
      _log('Transaction ID: $transactionId');
      _log('Movie ID: $movieId');
      _log('Endpoint: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('Request timeout');
          throw Exception('Request timeout');
        },
      );

      _log('Response status: ${response.statusCode}');
      _log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final success = data['status'] == 'success';
        
        if (success) {
          _log('✅ PPV payment verified successfully for Movie ID: $movieId');
          if (data['data'] != null) {
            final paymentData = data['data'] as Map<String, dynamic>;
            _log('Expiry date: ${paymentData['expdate']}');
            _log('Currency: ${paymentData['currency']}');
            
            // Store PPV expiry date if available (movie-specific)
            if (paymentData['expdate'] != null) {
              await prefs.setString(
                'ppv_expiry_$movieId',
                paymentData['expdate'].toString(),
              );
              _log('Stored PPV expiry date for Movie ID $movieId: ${paymentData['expdate']}');
            }
            
            // Store purchase record (mark this specific movie as purchased)
            await prefs.setBool('ppv_purchased_$movieId', true);
            _log('Marked Movie ID $movieId as purchased');
            
            // Store transaction ID for this movie (for reference)
            await prefs.setString('ppv_transaction_$movieId', transactionId);
            _log('Stored transaction ID for Movie ID $movieId: $transactionId');
          }
        } else {
          _log('❌ Verification failed: ${data['message'] ?? 'Unknown error'}');
        }
        
        return success;
      } else {
        _log('❌ HTTP error: ${response.statusCode}');
        try {
          final errorData = jsonDecode(response.body);
          _log('Error message: ${errorData['message'] ?? 'Unknown error'}');
        } catch (_) {
          _log('Error response: ${response.body}');
        }
        return false;
      }
    } catch (e, stackTrace) {
      _log('❌ Exception during verification: $e');
      _log('Stack trace: $stackTrace');
      return false;
    }
  }
}
