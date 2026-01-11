// lib/features/subscription/screen/flutterwave_payment_webview.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:Oloflix/features/subscription/data/flutterwave_payment_service.dart';

class FlutterwavePaymentWebView extends StatefulWidget {
  const FlutterwavePaymentWebView({
    super.key,
    required this.paymentUrl,
    required this.onPaymentComplete,
    this.planId,
    this.movieId,
    this.isPPV = false,
  });

  final String paymentUrl;
  final Function(String? transactionId, bool success) onPaymentComplete;
  final int? planId;
  final int? movieId;
  final bool isPPV;

  @override
  State<FlutterwavePaymentWebView> createState() => _FlutterwavePaymentWebViewState();
}

class _FlutterwavePaymentWebViewState extends State<FlutterwavePaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _extractedTransactionId;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'PaymentChannel',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('[Flutterwave WebView] JavaScript message: ${message.message}');
          try {
            final data = message.message;
            if (data.contains('transaction_id:') || data.contains('tx_ref:')) {
              final parts = data.split(':');
              if (parts.length > 1) {
                final txId = parts[1].trim();
                if (txId.isNotEmpty && _extractedTransactionId != txId && !_isVerifying) {
                  debugPrint('[Flutterwave WebView] ✅ Transaction ID from JS: $txId');
                  _extractedTransactionId = txId;
                  _verifyPayment(txId);
                }
              }
            }
          } catch (e) {
            debugPrint('[Flutterwave WebView] Error parsing JS message: $e');
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('[Flutterwave WebView] Page started: $url');
            _checkPaymentStatus(url);
          },
          onPageFinished: (String url) async {
            debugPrint('[Flutterwave WebView] Page finished: $url');
            setState(() => _isLoading = false);
            _checkPaymentStatus(url);
            
            // Try to extract transaction ID from page content using JavaScript
            await _extractTransactionIdFromPage();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('[Flutterwave WebView] Error: ${error.description}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment error: ${error.description}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) {
              debugPrint('[Flutterwave WebView] URL changed: ${change.url}');
              _checkPaymentStatus(change.url!);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  /// Check if the current URL indicates payment completion
  void _checkPaymentStatus(String url) {
    // Flutterwave success URLs typically contain transaction references
    // Common patterns: 
    // - /success, /successful, /complete, /callback
    // - Contains tx_ref, transaction_id, flw_ref, or transaction_id
    // - Contains status=successful or status=success
    // - Flutterwave callback URLs often have format: .../callback?tx_ref=...
    
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    // Check for success indicators in URL
    final path = uri.path.toLowerCase();
    final queryParams = uri.queryParameters;
    final fragment = uri.fragment;
    
    bool isSuccessPage = path.contains('success') || 
                        path.contains('successful') || 
                        path.contains('complete') ||
                        path.contains('callback') ||
                        path.contains('verify');

    // Extract transaction ID from various possible parameters
    // Flutterwave typically uses: tx_ref, transaction_id, flw_ref, or id
    String? transactionId = queryParams['tx_ref'] ?? 
                            queryParams['transaction_id'] ?? 
                            queryParams['flw_ref'] ??
                            queryParams['txRef'] ??
                            queryParams['transactionId'] ??
                            queryParams['id'] ??
                            queryParams['transaction_ref'];

    // Also check fragment for transaction ID
    if (transactionId == null && fragment.isNotEmpty) {
      final fragmentParams = Uri.splitQueryString(fragment);
      transactionId = fragmentParams['tx_ref'] ?? 
                      fragmentParams['transaction_id'] ?? 
                      fragmentParams['flw_ref'];
    }

    // Check for status parameter
    final status = queryParams['status']?.toLowerCase() ?? 
                   queryParams['Status']?.toLowerCase();
    if (status != null && (status == 'successful' || status == 'success' || status == 'completed')) {
      isSuccessPage = true;
    }

    // Flutterwave callback URLs often redirect to your backend callback URL
    // Check if this is a callback to your backend
    if (url.contains('flutterwave') || url.contains('rave')) {
      // This might be a Flutterwave internal page, continue monitoring
      debugPrint('[Flutterwave WebView] Flutterwave page detected: $url');
    }

    // Check if URL contains your backend callback (success indicator)
    final isBackendCallback = url.contains('103.208.183.250') || 
                             url.contains('oloflix') ||
                             url.contains('/api/payment/flutterwave');
    
    if (isBackendCallback && transactionId != null && transactionId.isNotEmpty) {
      // Backend callback with transaction ID - payment likely successful
      isSuccessPage = true;
    }

    // If we found a success page and have transaction ID, verify payment
    if (isSuccessPage && transactionId != null && transactionId.isNotEmpty) {
      if (_extractedTransactionId != transactionId && !_isVerifying) {
        debugPrint('[Flutterwave WebView] ✅ Payment success detected! Transaction ID: $transactionId');
        _extractedTransactionId = transactionId;
        _verifyPayment(transactionId);
      }
    } else if (isSuccessPage && transactionId == null) {
      // Success page but no transaction ID - try to extract from page content
      debugPrint('[Flutterwave WebView] Success page detected but no transaction ID in URL');
      // Will try to extract from page content in onPageFinished
    }

    // Check for failure indicators
    final isFailurePage = path.contains('fail') || 
                         path.contains('error') || 
                         path.contains('cancel') ||
                         path.contains('declined');
    
    if (isFailurePage && !_isVerifying) {
      debugPrint('[Flutterwave WebView] ❌ Payment failure detected');
      if (mounted) {
        widget.onPaymentComplete(null, false);
        Navigator.of(context).pop();
      }
    }
  }

  /// Try to extract transaction ID from page content using JavaScript
  Future<void> _extractTransactionIdFromPage() async {
    if (_isVerifying || _extractedTransactionId != null) return;
    
    try {
      // JavaScript to extract transaction ID from various possible locations
      final jsCode = '''
        (function() {
          // Try to find transaction ID in various formats
          var txId = null;
          
          // Check URL parameters
          var urlParams = new URLSearchParams(window.location.search);
          txId = urlParams.get('tx_ref') || 
                 urlParams.get('transaction_id') || 
                 urlParams.get('flw_ref') ||
                 urlParams.get('id');
          
          // If not in URL, check page content
          if (!txId) {
            // Look for transaction ID in text content
            var bodyText = document.body.innerText || '';
            var matches = bodyText.match(/(?:tx_ref|transaction[_-]?id|flw_ref)[:=\\s]+([A-Z0-9_-]+)/i);
            if (matches && matches[1]) {
              txId = matches[1];
            }
          }
          
          // Check for Flutterwave success indicators
          if (!txId) {
            var successElements = document.querySelectorAll('[class*="success"], [id*="success"]');
            if (successElements.length > 0) {
              // Try to find transaction reference nearby
              var parentText = successElements[0].parentElement?.innerText || '';
              var refMatch = parentText.match(/(?:ref|reference|transaction)[:=\\s]+([A-Z0-9_-]+)/i);
              if (refMatch && refMatch[1]) {
                txId = refMatch[1];
              }
            }
          }
          
          // Check localStorage or sessionStorage (Flutterwave sometimes stores it)
          if (!txId) {
            try {
              txId = localStorage.getItem('tx_ref') || 
                     localStorage.getItem('transaction_id') ||
                     sessionStorage.getItem('tx_ref') ||
                     sessionStorage.getItem('transaction_id');
            } catch(e) {}
          }
          
          if (txId) {
            PaymentChannel.postMessage('transaction_id:' + txId);
          }
        })();
      ''';
      
      await _controller.runJavaScript(jsCode);
    } catch (e) {
      debugPrint('[Flutterwave WebView] Error extracting transaction ID from page: $e');
    }
  }

  /// Verify the payment with backend
  Future<void> _verifyPayment(String transactionId) async {
    if (_isVerifying) return;
    
    setState(() => _isVerifying = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifying payment...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    try {
      final flutterwaveService = FlutterwavePaymentService.instance;
      bool success = false;

      if (widget.isPPV && widget.movieId != null) {
        success = await flutterwaveService.verifyPPV(
          transactionId: transactionId,
          movieId: widget.movieId!,
        );
      } else if (widget.planId != null) {
        success = await flutterwaveService.verifySubscription(
          transactionId: transactionId,
          planId: widget.planId!,
        );
      } else {
        debugPrint('[Flutterwave WebView] ❌ Missing planId or movieId for verification');
        success = false;
      }

      debugPrint('[Flutterwave WebView] Verification result: $success for transaction: $transactionId');
      
      if (mounted) {
        widget.onPaymentComplete(transactionId, success);
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error verifying payment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        widget.onPaymentComplete(transactionId, false);
        Navigator.of(context).pop();
      }
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutterwave Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (!_isVerifying) {
              widget.onPaymentComplete(null, false);
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading || _isVerifying)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      _isVerifying ? 'Verifying payment...' : 'Loading payment page...',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
