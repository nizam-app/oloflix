import 'package:Oloflix/core/constants/image_control/image_path.dart';
import 'package:Oloflix/core/utils/logOut_botton.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/features/subscription/logic/payment_reverpod.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PaymentMethod extends ConsumerStatefulWidget { // ← আগে StatefulWidget ছিল
  const PaymentMethod({
    super.key,
    required this.planId,
    required this.amount,
    required this.title,
    required this.isInternational,
  });
  final int? planId;
  final String? amount;
  final String? title;
  final bool isInternational;
  static final routeName = '/payment';

  @override
  ConsumerState<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends ConsumerState<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    final iapState = ref.watch(iapControllerProvider);
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
              
              ApplePay(context, onPay: () async {
                final pid = productIdForPlan(isInternational: widget.isInternational);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing purchase...')),
                );

                final ok = await ref.read(iapControllerProvider.notifier).buy(pid);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok ? 'Subscription active ✅' : 'Payment failed or canceled')),
                );

                if (ok) {
                  // TODO: premium unlock / navigation
                  // context.go('/homePage');
                }
              }, busy: busy),

              SizedBox(height: 20.h),
              FooterSection(),
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
          fit: BoxFit.cover, // Adjust the fit as needed
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
                child: Text(
                  "Home",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.arrow_right, size: 20),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  content.push("/dashboardScreen");
                },
                child: Text(
                  "Dashboard",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.arrow_right, size: 20),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  content.push("/payment");
                },
                child: Text(
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
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF1A093F),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Payment Method",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 4,
          width: 40,
          color: Colors.red,
        ),
        SizedBox(height: 10),
        Text(
          'You have Selected Yearly Plan (\$)',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 5),

        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "You are Logged in as ",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              TextSpan(
                text: "palashchandra900189@gmail.com ",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    "If you Would Like to Use a Different Account for this Subscription, ",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              TextSpan(
                text: "Logout Now.",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {

                    Get.snackbar("Logout", "You have been logged out");
                    showLogOutDialog(context);
                  },
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),
        InkWell(
          onTap: (){
                context.push(SubscriptionPlanScreen.routeName);
          },
          child: Container(
                width: 130,
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
                  borderRadius: BorderRadius.circular(4),
                ),
                child:  Text("CHANGE PLAN", style: TextStyle(color: Colors.white)),
              ),
        ),

      ],

    ),
  );
}


// আগের ApplePay(...) ফাংশনটাকে এরকম করে নাও:
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
            height: 4, width: 44,
            decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          ApplePayButton(
            onPressed: busy ? (){} : onPay, // এখানে শুধু কলব্যাক ডাকছি
            variant: ApplePayButtonVariant.white,
            label: busy ? 'Processing...' : 'Pay',
          ),
        ],
      ),
    ),
  );
}



Widget paystackPayment(BuildContext content) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF1A093F),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Column(
        children: [
          Text(
          "paystack -(Pay with ATM Card) ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,

          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 4,
          width: 40,
          color: Colors.red,
        ),

         SizedBox(height: 10.h),
        InkWell(
          onTap: (){

          },
          child: Container(
                   width: 95,
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
                  borderRadius: BorderRadius.circular(4),
                ),
                child:  Text("PAY NOW", style: TextStyle(color: Colors.white)),
              ),
        ),

        ],
      ),
    ),

    );
}


Widget FlutterWavePayment(BuildContext content) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF1A093F),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Column(
        children: [
          Align(alignment: Alignment.center,),
          Text(

          "Flutterwave -(Pay with Card, Bank, Transfer, USSD)",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,

          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 4,
          width: 40,
          color: Colors.red,
        ),

         SizedBox(height: 10.h),
        InkWell(
          onTap: (){

          },
          child: Container(
                width: 95,
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
                  borderRadius: BorderRadius.circular(4),
                ),
                child:  Text("PAY NOW", style: TextStyle(color: Colors.white)),
              ),
        ),

        ],
      ),
    ),

    );
}
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
              ? BorderSide(color: Colors.black, width: 1)
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