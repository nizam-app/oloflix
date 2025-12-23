// Flutter imports:
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

class PricingRefundsScreen extends StatelessWidget {
  const PricingRefundsScreen({super.key});
  static final routeName = "/pricingRefundsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              AbouteBackgrountImage(screenName: "Pricing & Refunds"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Membership Plans Section
                    Container(
                      color:
                          Colors.green, // For the "SUBSCRIPTION PLANS" banner
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
                      child: Center(
                        child: Text(
                          "SUBSCRIPTION PLANS",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildPlanCard(
                      title: "Half Year Membership",
                      price: "₦8,000.00",
                      duration: "expires after 6 Months",
                      context:   context
                    ),
                    SizedBox(height: 16.h),

                    // Yearly Plan
                    _buildPlanCard(
                      title: "Yearly Membership",
                      price: "₦15,000.00",
                      duration: "expires after 1 Year",
                      context:  context
                    ),
                    SizedBox(height: 16.h),

                    // Pay Per View
                    _buildPlanCard(
                      title: "Pay Per View",
                      price: "₦1,000.00",
                      duration: "expires after 48 Hours",
                      context:     context
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      "Signup and Subscribe to a Membership plan to enjoy our contents.",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Refund Policy Section
                    _buildSectionTitle("Refund Policy:"),
                    SizedBox(height: 12.h),
                    _buildPolicyParagraph(
                      "1.1. Oloflix has a strict no-refund policy for subscriptions. Due to the nature of our digital offerings We do not issue refunds for any subscription made on our platforms - (website, android app and ios app), regardless of whether the service has been used or not. We have designed our platform to enable all users see and read all information about available contents on our platform, this is aimed at ensuring users make \"informed decision\" before subscribing for full access to those contents.",
                    ),
                    _buildPolicyParagraph(
                      "1.2. If you have issues like multiple billings, do contact us We will investigate and issue a refund of the extra charges involved.",
                    ),
                    _buildPolicyParagraph(
                      "1.3. In case of any dissatisfaction with our service or technical issues, we encourage you to reach out to our customer support team. We will do our best to address your concerns and resolve any issues you may encounter while using our platform.",
                    ),
                    _buildPolicyParagraph(
                      "1.4. We reserve the right to amend or modify this refund policy at any time without prior notice.",
                    ),
                    SizedBox(height: 24.h),

                    // Cancellation Policy Section
                    _buildSectionTitle("Cancellation Policy:"),
                    SizedBox(height: 12.h),
                    _buildPolicyParagraph(
                      "2.1. All our subscriptions are time-based (1mth, 2mths etc), Once you have subscribed to our service, it is considered final and non-refundable.",
                    ),
                    _buildPolicyParagraph(
                      "2.2. Subscriptions on oloflix may be billed on a recurring basis according to the subscription plan chosen by the user. If you wish to discontinue using our service, you may cancel the auto-renewal of your subscription, but no refunds will be issued for the remaining subscription period.",
                    ),
                    _buildPolicyParagraph(
                      "2.3. If you cancel the auto-renewal, your subscription will remain active until the end of the current billing cycle. After the expiration of the current billing cycle, you will no longer be charged, and your access to the premium features will be revoked.",
                    ),
                    SizedBox(height: 24.h),

                    // Customer Support Section
                    _buildSectionTitle("Customer Support:"),
                    SizedBox(height: 12.h),
                    _buildPolicyParagraph(
                      "3.1. If you have any questions, concerns, or technical issues, please feel free to contact our customer support team. We are available business working days to assist you.",
                    ),
                    _buildPolicyParagraph(
                      "3.2. You can contact our customer support team through the following channels:",
                    ),
                    SizedBox(height: 8.h),
                    _buildContactInfo("Phone: 0904-444-4442"),
                    _buildContactInfo("Email: support@oloflix.com"),
                    SizedBox(height: 16.h),

                    Text(
                      "Please remember that by using Oloflix, you agree to comply with this Cancellation and Refund Policy. If you do not agree with any part of this policy, we advise you not to subscribe to our services.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Return to Home Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push(BottomNavBar.routeName);
                        },
                        child: Text("Return to Home"),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String duration,
    required BuildContext context
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push(SubscriptionPlanScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Text("Select"),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              price,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              duration,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 14.sp, height: 1.5),
      ),
    );
  }

  Widget _buildContactInfo(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}