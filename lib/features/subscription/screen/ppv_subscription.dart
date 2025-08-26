// lib/features/subscription/screen/ppv_subscription_plan_screen.dart
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PPVSubscriptionPlanScreen extends StatefulWidget {
  const PPVSubscriptionPlanScreen({super.key, required this.movieId});
  static final routeName = "/PPVSubscriptionPlanScreen";

  final int movieId; // ← যে মুভি থেকে আসছে তার আইডি

  @override
  State<PPVSubscriptionPlanScreen> createState() => _PPVSubscriptionPlanScreenState();
}

class _PPVSubscriptionPlanScreenState extends State<PPVSubscriptionPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0320),
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
             CustomHomeTopperSection(),

            planCard(
              title: "ELENIYAN - The return of the King [PART 2]",
              price: "₦ 1500",
              duration: "3 Days",
              onSelect: () {
                context.push(
                  '/payment',
                  extra: {
                    'planId': null,
                    'amount': '1500',
                    'title': 'ELENIYAN [PART 2]',
                    'isInternational': 2,        // ← PPV
                    'movieId': widget.movieId,   // ← ব্যাকএন্ডে যাবে
                  },
                );
              },
            ),

            SizedBox(height: 30.h),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget planCard({
    required String title,
    required String price,
    required String duration,
    required VoidCallback onSelect,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A093F), Color(0xFF1A093F)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurpleAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          Text(price, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(duration, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSelect,
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