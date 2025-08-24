// Flutter imports:
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PPVSubscriptionPlanScreen extends StatefulWidget {
  const PPVSubscriptionPlanScreen({super.key});
  static final routeName = "/PPVSubscriptionPlanScreen";

  @override
  State<PPVSubscriptionPlanScreen> createState() => _PPVSubscriptionPlanScreenState();
}

class _PPVSubscriptionPlanScreenState extends State<PPVSubscriptionPlanScreen> {
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
            CustomHomeTopperSection()       ,

            planCard(
              title: "ELENIYAN - The return of the King [PART 2]",
              price: "₦ 1500",
              duration: "3 Days",
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.red],
              ),
            ),
           
            SizedBox(height: 30.h),
            FooterSection(),
          ],
        ),
      ),
    );
  }



  Widget planCard({
    required String title,
    required String price,
    required String duration,
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