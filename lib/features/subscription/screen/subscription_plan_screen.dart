// Flutter imports:
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});
  static final routeName = "/subscriptionPlanScreen";

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  final textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0320), // dark purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Subscription Plan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            planCard(
              title: "Yearly Plan",
              price: "₦ 15,000.00",
              duration: "1 Year(s)",
              deviceLimit: "1000000",
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.red],
              ),
            ),
            const SizedBox(height: 20),
            planCard(
              title: "Yearly Plan (\$) (International)",
              price: "\$ 25.00",
              duration: "1 Year(s)",
              deviceLimit: "1000000",
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.red],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1A093F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "I Have Coupon Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 4,
                    width: 40,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 30),
                  _buildEmailField(),
                  SizedBox(height: 20.h),
                  CustomButtom(
                    text: "APPLY COUPON",
                    onTap: () => context.push("/"),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: textCtrl,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget planCard({
    required String title,
    required String price,
    required String duration,
    required String deviceLimit,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A093F), Color(0xFF1A093F)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurpleAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            price,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(duration, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            "Device Limit - $deviceLimit",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push("/payment"); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("SELECT PLAN"),
            ),
          ),
        ],
      ),
    );
  }
}

