// lib/features/subscription/screen/subscription_plan_screen.dart
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';
import 'package:Oloflix/features/subscription/logic/plan_reverpod.dart';
import 'package:Oloflix/features/subscription/model/plan_model.dart';
import 'package:Oloflix/features/subscription/screen/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class SubscriptionPlanScreen extends ConsumerStatefulWidget {
  const SubscriptionPlanScreen({super.key});
  static final routeName = "/subscriptionPlanScreen";

  @override
  ConsumerState<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends ConsumerState<SubscriptionPlanScreen> {
  final textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final asyncPlans = ref.watch(plansProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0320),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Subscription Plan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.refresh(plansProvider),
          ),
        ],
      ),
      body: asyncPlans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _errorView(
          context,
          'Failed to load plans: $e',
          onRetry: () => ref.refresh(plansProvider),
        ),
        data: (plans) {
          if (plans.isEmpty) {
            return _errorView(
              context,
              'No plans available',
              onRetry: () => ref.refresh(plansProvider),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 CustomHomeTopperSection(),
                SizedBox(height: 16.h),

                // ডাইনামিকভাবে কার্ড রেন্ডার
                ...plans.map((p) => Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: planCard(
                    plan: p,
                    onSelect: () {
                      context.push(
                        '${PaymentMethod.routeName}',
                        extra: {
                          'planId': p.id,
                          'amount': p.price,
                          'title': p.name,
                          'isInternational': p.isInternational,
                        },
                      );
                    },
                  ),
                )),

                const SizedBox(height: 10),
                _couponBox(context),

                SizedBox(height: 30.h),
                const FooterSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _couponBox(BuildContext context) {
    return Container(
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
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Container(height: 4, width: 40, color: Colors.red),
          const SizedBox(height: 30),
          _buildCouponField(),
          SizedBox(height: 20.h),
          CustomButtom(
            text: "APPLY COUPON",
            onTap: () {
              // TODO: কুপন এপিআই হিট করে ডিসকাউন্ট অ্যাপ্লাই করুন
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coupon applied (demo)')),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildCouponField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: textCtrl,
      decoration: InputDecoration(
        hintText: 'Enter coupon code',
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget planCard({
    required Plan plan,
    required VoidCallback onSelect,
  }) {
    final symbol = plan.isInternational ? '\$' : '₦';
    final durationText = '${plan.duration} Year(s)';
    final deviceLimitText = plan.deviceLimit.toString();

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
          // ফিচার ট্যাগ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              plan.name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // প্রাইস
          Text(
            '$symbol ${plan.price}',
            style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(durationText, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text('Device Limit - $deviceLimitText', style: const TextStyle(color: Colors.white70)),
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

  Widget _errorView(BuildContext context, String msg, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
            const SizedBox(height: 12),
            Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}