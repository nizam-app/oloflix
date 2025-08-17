// Flutter imports:
import 'package:flutter/material.dart';
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static final routeName = "/dashboardScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              const AbouteBackgrountImage(screenName: "Dashboard  Screen"),
              AccountContent(),
              FooterSection()
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- Custom Codebase ---------------------------

/// The main content section for the user's account page.
///
/// This widget combines the profile, subscription, invoice, and history sections.
class AccountContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserProfileSection(),
        MySubscriptionSection(),
        LastInvoiceSection(),
        UserHistorySection(),
      ],
    );
  }
}

/// Displays the user's profile picture, name, and email.
class UserProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileImage(),
          const SizedBox(height: 16.0),
          const Text(
            "christian onyejiuwa",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            "onyejiuwachristian1@gmail.com",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildEditButton(),
          const SizedBox(height: 8.0),
          _buildAccountDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.edit, color: Colors.black),
      label: const Text(
        "EDIT",
        style: TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildAccountDeleteButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.delete, color: Colors.white),
      label: const Text(
        "ACCOUNT DELETE",
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

/// Displays the user's subscription details.
class MySubscriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("My Subscription"),
          const SizedBox(height: 16.0),
          _buildSubscriptionDetail(
            "Current Plan:",
            _buildPlanTag("Yearly Plan"),
          ),
          const SizedBox(height: 8.0),
          _buildSubscriptionDetail(
            "Subscription expires on:",
            _buildPlanTag("December, 30, 2030"),
          ),
          const SizedBox(height: 16.0),
          _buildUpgradeButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubscriptionDetail(String label, Widget value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        value,
      ],
    );
  }

  Widget _buildPlanTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        "UPGRADE PLAN",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

/// Displays the user's last invoice details.
class LastInvoiceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Last Invoice"),
          const SizedBox(height: 16.0),
          _buildInvoiceDetail("Date:"),
          _buildInvoiceDetail("Plan:", _buildPlanTag("Yearly Plan")),
          _buildInvoiceDetail("Amount:"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInvoiceDetail(String label, [Widget? value]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          if (value != null) value,
        ],
      ),
    );
  }

  Widget _buildPlanTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

/// Displays a scrollable list of tabs for user history.
class UserHistorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("User History"),
          const SizedBox(height: 16.0),
          _buildHistoryTabs(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHistoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildHistoryTab("Plan"),
          _buildHistoryTab("Amount"),
          _buildHistoryTab("Payment Gateway"),
          _buildHistoryTab("Payment Id"),
          _buildHistoryTab("Payment Date"),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}