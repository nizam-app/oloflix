// lib/features/subscription/screen/payment.dart
import 'package:Oloflix/core/constants/image_control/image_path.dart';
import 'package:Oloflix/core/utils/logOut_botton.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/features/subscription/logic/payment_reverpod.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'dart:io' show Platform;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../deshboard/logic/deshboard_reverport.dart';

class PaymentMethod extends ConsumerStatefulWidget {
  const PaymentMethod({
    super.key,
    this.planId,
    this.amount,
    this.title,
    required this.isInternational, // 0=Local, 1=USD, 2=PPV
    this.movieId,                  // PPV হলে দরকার
  });

  final int? planId;
  final String? amount;
  final String? title;
  final int isInternational;
  final int? movieId;

  static final routeName = '/payment';

  @override
  ConsumerState<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends ConsumerState<PaymentMethod> {
  Future<void> _handlePayment(BuildContext context, WidgetRef ref) async {
    final pid = productIdForPlan(isInternational: widget.isInternational);

    // IAP service instance
    final svc = ref.read(iapServiceProvider);

    if (widget.isInternational == 2) {
      // 👉 PPV
      if (widget.movieId == null || widget.movieId == 0) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Movie not found for PPV purchase'),
            ),
          );
        }
        return;
      }
      svc.setExtraPayload({
        'source': 'ppv',
        'movieId': widget.movieId, // int
        'days': 3,                 // চাইলে UI থেকে ডাইনামিক
      });
    } else {
      // 👉 Subscription
      if (widget.planId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Plan not found for subscription'),
            ),
          );
        }
        return;
      }
      svc.setExtraPayload({
        'source': 'subscription',
        'planId': widget.planId, // int
      });
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing purchase...')),
      );
    }

    final ok = await ref.read(iapControllerProvider.notifier).buy(pid);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok ? 'Subscription activated successfully! ✅' : 'Payment failed or canceled',
          ),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );
    }

    if (ok) {
      // Refresh user profile to update subscription status
      ref.invalidate(profileProvider);
      
      // Show success message and navigate
      if (context.mounted) {
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          context.go('/homePage');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(iapControllerProvider); // init নিশ্চিত করতে
    final busy = ref.watch(purchaseBusyProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              dashboardTextImages(context),
              SizedBox(height: 10.h),
              paymentMethodSelect(context),
              SizedBox(height: 10.h),

              // Platform-specific payment button
              Platform.isAndroid
                  ? GooglePay(
                      context,
                      onPay: () => _handlePayment(context, ref),
                      busy: busy,
                    )
                  : ApplePay(
                      context,
                      onPay: () => _handlePayment(context, ref),
                      busy: busy,
                    ),

              SizedBox(height: 20.h),
              const FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget dashboardTextImages(BuildContext content) {
  return SafeArea(
    child: Container(
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.Mbackground),
          opacity: 0.3,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Payment Method ",
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => content.push("/homePage"),
                child: const Text(
                  "Home",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_right, size: 20),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  content.push("/dashboardScreen");
                },
                child: const Text(
                  "Dashboard",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_right, size: 20),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  content.push("/payment");
                },
                child: const Text(
                  "Payment Method",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget paymentMethodSelect(BuildContext context) {
  return Container(
    child: Consumer(
      builder: (context, ref, _) {
        final user = ref.watch(userProvider);
        final email = user?.email ?? 'Unknown';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Method",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(height: 4, width: 40, color: Colors.red),
            const SizedBox(height: 10),

            const Text(
              'You have Selected Yearly Plan (\$)',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 5),

            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "You are Logged in as ",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  TextSpan(
                    text: "$email ",
                    style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: "If you Would Like to Use a Different Account for this Subscription, ",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  TextSpan(
                    text: "Logout Now.",
                    style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.snackbar("Logout", "You have been logged out");
                        showLogOutDialog(context);
                      },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            InkWell(
              onTap: () { context.go(SubscriptionPlanScreen.routeName);},
              child: Container(
                width: 130,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text("CHANGE PLAN", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    ),
  );
}

// ApplePay UI wrapper
Widget ApplePay(BuildContext content, {required VoidCallback onPay, bool busy = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF1A093F),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Apple Pay",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 4,
            width: 44,
            decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          ApplePayButton(
            onPressed: busy ? () {} : onPay,
            variant: ApplePayButtonVariant.white,
            label: busy ? 'Processing...' : 'Pay',
          ),
        ],
      ),
    ),
  );
}

// Apple Pay button widget
class ApplePayButton extends StatelessWidget {
  const ApplePayButton({
    super.key,
    required this.onPressed,
    this.variant = ApplePayButtonVariant.black,
    this.label = 'Pay',
    this.height = 48,
    this.borderRadius = 10,
  });

  final VoidCallback onPressed;
  final ApplePayButtonVariant variant;
  final String label;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isBlack = variant == ApplePayButtonVariant.black;
    final isWhite = variant == ApplePayButtonVariant.white;
    final bg = isBlack
        ? Colors.black
        : isWhite
        ? Colors.white
        : Colors.transparent;
    final fg = isBlack ? Colors.white : Colors.black;

    return SizedBox(
      height: height,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: isWhite || variant == ApplePayButtonVariant.outline
              ? const BorderSide(color: Colors.black, width: 1)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.apple, color: fg, size: 22),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ApplePayButtonVariant { black, white, outline }

// Google Pay UI wrapper
Widget GooglePay(BuildContext content, {required VoidCallback onPay, bool busy = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF1A093F),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Google Pay",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 4,
            width: 44,
            decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          GooglePayButton(
            onPressed: busy ? () {} : onPay,
            label: busy ? 'Processing...' : 'Pay with Google',
          ),
        ],
      ),
    ),
  );
}

// Google Pay button widget
class GooglePayButton extends StatelessWidget {
  const GooglePayButton({
    super.key,
    required this.onPressed,
    this.label = 'Pay with Google',
    this.height = 48,
    this.borderRadius = 10,
  });

  final VoidCallback onPressed;
  final String label;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Google Pay icon (using Material icon as fallback)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.account_balance_wallet, color: Colors.blue, size: 22),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}