import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ... your other imports

class PricingRefundsScreen extends StatelessWidget {
  const PricingRefundsScreen({super.key});

  static final routeName = "/pricingRefundsScreen";

  @override
  Widget build(BuildContext context) {
    // Assuming a dark theme is applied elsewhere or you set it for this screen
    return Scaffold(
      // Potentially set a dark background for the Scaffold if not globally themed
      // backgroundColor: Colors.grey[900], // Example dark background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomHomeTopperSection(), // Keep if needed
              // AbouteBackgrountImage(screenName: "Pricing & Refunds"), // This might need to be replaced or adapted

              // --- Start: Modified Section to match image ---
              Container(
                color: Colors.green, // For the "SUBSCRIPTION PLANS" banner
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Level Price",
                      style: TextStyle(
                        fontSize: 22.sp, // Adjust size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // Assuming white text on dark background
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Plan Items - using a new _buildImageStyledPlanItem
                    _buildImageStyledPlanItem(
                      context,
                      // Pass context if needed for theme or screen size
                      planName: "Basic",
                      price: "#950.00",
                      description: "Membership\nexpires after 15\nDays.",
                    ),
                    SizedBox(height: 16.h),
                    _buildImageStyledPlanItem(
                      context,
                      planName: "Standard",
                      price: "#1,400.00",
                      description: "Membership\nexpires after 1\nMonth.",
                    ),
                    SizedBox(height: 16.h),
                    _buildImageStyledPlanItem(
                      context,
                      planName: "Premium",
                      price: "#2,500.00",
                      description: "Membership\nexpires after 2\nMonths.",
                    ),
                    SizedBox(height: 16.h),
                    _buildImageStyledPlanItem(
                      context,
                      planName: "Quater\nPlan", // Match line break from image
                      price: "#3,800.00",
                      description: "Membership\nexpires after 3\nMonths.",
                    ),
                    // ... Add other plans similarly ...
                    SizedBox(height: 24.h),
                    // ... Rest of your content (Signup text, Refund Policy, etc.)
                    // You'll need to adjust the styling of these sections as well
                    // if they should also match a dark theme.
                  ],
                ),
              ),
              // FooterSection(), // Keep if needed
            ],
          ),
        ),
      ),
    );
  }

  // New widget builder for the image's style
  Widget _buildImageStyledPlanItem(BuildContext context, {
    required String planName,
    required String price,
    required String description,
  }) {
    // Determine text color based on background, assuming white for dark bg
    const textColor = Colors.white;
    const selectTextColor = Colors.white; // Or a slightly different shade

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          Expanded(
            flex: 2,
            // Adjust flex factor as needed for "Basic", "Standard" etc.
            child: Text(
              planName,
              style: TextStyle(
                fontSize: 16.sp,
                color: textColor,
                height: 1.3, // Adjust line height for multi-line plan names
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 5, // Adjust flex factor for price and description
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: textColor.withOpacity(0.8), // Slightly dimmer
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 2, // Adjust flex factor for "Select"
            child: GestureDetector(
              onTap: () {
                // Handle select action
                print("$planName selected");
              },
              child: Padding(
                padding: EdgeInsets.only(top: 2.h), // Align with price visually
                child: Text(
                  "Select",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: selectTextColor,
                    // fontWeight: FontWeight.bold, // If Select should be bold
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Your existing _buildSectionTitle, _buildPolicyParagraph, etc. might also
  // need style adjustments (e.g., text color) if the background is dark.
  // For example:
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Assuming dark theme
      ),
    );
  }

  // Original _buildPlanCard - keep if you want to switch between styles or for reference
  Widget _buildPlanCard({
    required String title,
    required String price,
    required String duration,
  }) {
    return Card(
      elevation: 3,
      // Consider card color if on dark background
      // color: Colors.grey[800],
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
                    // color: Colors.white, // If card is dark
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle select button press
                  },
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
                color: Colors.blue, // Keep or change as per new design
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              duration,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[400], // Lighter grey for dark background
              ),
            ),
          ],
        ),
      ),
    );
  }
// ... rest of your helper methods (adjust their text colors if needed)
}