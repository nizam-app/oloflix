
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

import 'package:Oloflix/features/deshboard/logic/deshboard_reverport.dart';
import 'package:Oloflix/features/deshboard/model/deshboard_model.dart';

import '../../profile/screen/profile_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  static final routeName = "/dashboardScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // 1) cache drop
            ref.invalidate(profileProvider);
            // 2) নতুন ডেটা আসা পর্যন্ত অপেক্ষা
            await ref.read(profileProvider.future);
          },
          child:  SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHomeTopperSection(),
                AbouteBackgrountImage(screenName: "Dashboard  Screen"),
                AccountContent(),
                FooterSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// --------------------------- Custom Codebase ---------------------------

class AccountContent extends StatelessWidget {
  const AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
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
class UserProfileSection extends ConsumerWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final displayName = (user?.name.isNotEmpty == true) ? user!.name : "—";
    final displayEmail = (user?.email.isNotEmpty == true) ? user!.email : "—";

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileImage(),
          const SizedBox(height: 16.0),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            displayEmail,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildEditButton(context),
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
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.push(ProfileScreen.routeName);
      },
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
class MySubscriptionSection extends ConsumerWidget {
  const MySubscriptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final planText = planLabelFromId(user?.planId);
    final expText = _fmtDate(user?.expDate) ?? 'N/A';

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
          _sectionTitle("My Subscription"),
          const SizedBox(height: 16.0),
          _rowDetail("Current Plan:", _pill(planText)),
          const SizedBox(height: 8.0),
          _rowDetail("Subscription expires on:", _pill(expText)),
          const SizedBox(height: 16.0),
          _upgradeButton(context),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  static Widget _rowDetail(String label, Widget value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Colors.white)),
      value,
    ],
  );

  static Widget _pill(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );

  static Widget _upgradeButton(BuildContext context) => ElevatedButton(
    onPressed: () {context.push(SubscriptionPlanScreen.routeName);},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(double.infinity, 50),
    ),
    child: const Text("UPGRADE PLAN", style: TextStyle(color: Colors.white)),
  );
}

/// Displays the user's last invoice details.
class LastInvoiceSection extends ConsumerWidget {
  const LastInvoiceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    String date = '—';
    String plan = '—';
    String amount = '—';

    if (transactions.isNotEmpty) {
      final last = _latestTransaction(transactions);
      date = _fmtDate(last.date) ?? '—';
      plan = planLabelFromId(last.planId);
      amount = last.paymentAmount;
    }

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
          _sectionTitle("Last Invoice"),
          const SizedBox(height: 16.0),
          _row("Date:", date),
          _row("Plan:", plan),
          _row("Amount:", amount),
        ],
      ),
    );
  }

  static Transaction _latestTransaction(List<Transaction> list) {
    list.sort((a, b) => b.date.compareTo(a.date));
    return list.first;
  }

  static Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  static Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

/// Shows a nice, scrollable user history table (transactions).
class UserHistorySection extends ConsumerWidget {
  const UserHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txns = ref.watch(transactionsProvider);

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
          _titleRow(),
          const SizedBox(height: 12),
          if (txns.isEmpty)
            const Text("No history found",
                style: TextStyle(color: Colors.white70))
          else
            _historyTable(txns),
        ],
      ),
    );
  }

  Widget _titleRow() => Row(
    children: const [
      Icon(Icons.receipt_long, color: Colors.white),
      SizedBox(width: 8),
      Text(
        "User History",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  Widget _historyTable(List<Transaction> txns) {
    final rows = txns
        .map((t) => DataRow(cells: [
      DataCell(Text(planLabelFromId(t.planId),
          style: const TextStyle(color: Colors.white))),
      DataCell(Text(t.paymentAmount,
          style: const TextStyle(color: Colors.white))),
      DataCell(Text(t.gateway,
          style: const TextStyle(color: Colors.white))),
      DataCell(Text(t.paymentId,
          style: const TextStyle(color: Colors.white))),
      DataCell(Text(_fmtDate(t.date) ?? '—',
          style: const TextStyle(color: Colors.white))),
    ]))
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        dataTextStyle: const TextStyle(color: Colors.white),
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text('Plan')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Gateway')),
          DataColumn(label: Text('Payment Id')),
          DataColumn(label: Text('Payment Date')),
        ],
        rows: rows,
      ),
    );
  }
}

/// ---------- Utils ----------

String? _fmtDate(DateTime? dt) {
  if (dt == null) return null;
  return DateFormat('d MMM yyyy').format(dt);
}