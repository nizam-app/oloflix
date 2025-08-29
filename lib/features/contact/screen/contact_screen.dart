// Flutter
import 'package:Oloflix/features/contact/logic/contract_reverpot.dart';
import 'package:flutter/material.dart';
// Packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});
  static const routeName = "/ContactScreen";
  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _name = TextEditingController(),
      _email = TextEditingController(),
      _phone = TextEditingController(),
      _subject = TextEditingController(),
      _msg = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() { _name.dispose(); _email.dispose(); _phone.dispose(); _subject.dispose(); _msg.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!(_key.currentState?.validate() ?? false)) return;

    // progress
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(contactControllerProvider.notifier).submit(
        name: _name.text,
        email: _email.text,
        phone: _phone.text,
        subject: _subject.text,
        message: _msg.text,
      );

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // close progress

      // success
      _name.clear(); _email.clear(); _phone.clear(); _subject.clear(); _msg.clear();
      await showDialog(
        context: context,
        useRootNavigator: true,
        builder: (d) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Your message was sent.'),
          actions: [TextButton(onPressed: () => Navigator.of(d).pop(), child: const Text('OK'))],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // close progress
      await showDialog(
        context: context,
        useRootNavigator: true,
        builder: (d) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [TextButton(onPressed: () => Navigator.of(d).pop(), child: const Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomHomeTopperSection(),
            const AbouteBackgrountImage(screenName: "Contact"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Form(
                key: _key,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  BuildContactFormField(label: "Name", hint: "Name", controller: _name,
                      validator: (v)=> (v==null||v.trim().isEmpty)?'Enter name':null),
                  SizedBox(height: 16.h),
                  BuildContactFormField(label: "Email", hint: "Email", controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v)=> (v==null||!v.contains('@'))?'Enter valid email':null),
                  SizedBox(height: 16.h),
                  BuildContactFormField(label: "Phone Number", hint: "Phone Number",
                      controller: _phone, keyboardType: TextInputType.phone),
                  SizedBox(height: 16.h),
                  BuildContactFormField(label: "Subject", hint: "Subject",
                      controller: _subject, validator: (v)=> (v==null||v.trim().isEmpty)?'Enter subject':null),
                  SizedBox(height: 16.h),
                  BuildContactFormField(label: "Your Message", hint: "Your Message...",
                      controller: _msg, maxLines: 5, validator: (v)=> (v==null||v.trim().isEmpty)?'Enter message':null),
                  SizedBox(height: 24.h),
                  BuildSubmitButton(onTap: _submit),
                  SizedBox(height: 24.h),
                  const BuildSupportText(),
                  SizedBox(height: 32.h),
                  BuildContactInformationSection.generalEnquiries(),
                  SizedBox(height: 24.h),
                  BuildContactInformationSection.salesAndSupport(),
                  SizedBox(height: 32.h),
                ]),
              ),
            ),
            FooterSection(),
          ]),
        ),
      ),
    );
  }
}

// ================== Reusable UI (look unchanged) ==================

class BuildContactFormField extends StatelessWidget {
  final String label, hint;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const BuildContactFormField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      SizedBox(height: 8.h),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AllColor.blue, width: 1.5)),
          border: const OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: maxLines > 1 ? 16.h : 0),
        ),
        maxLines: maxLines,
      ),
    ],
  );
}

class BuildSubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  const BuildSubmitButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AllColor.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text("SUBMIT", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}

class BuildSupportText extends StatelessWidget {
  const BuildSupportText({super.key});
  @override
  Widget build(BuildContext context) => Text(
    "We are available to support you! Just Fill The Form",
    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
    textAlign: TextAlign.center,
  );
}

class BuildContactInformationSection extends StatelessWidget {
  final String title, phone, email;
  const BuildContactInformationSection({super.key, required this.title, required this.phone, required this.email});

  factory BuildContactInformationSection.generalEnquiries() => const BuildContactInformationSection(
      title: "For General Enquiries:", phone: "Phone: +1 (416) 276-4403 | +234-904-444-4442", email: "Email: admin@oloflix.tv");

  factory BuildContactInformationSection.salesAndSupport() => const BuildContactInformationSection(
      title: "For Sales & Support:", phone: "Phone: +1 (416) 276-4403 | +234-904-444-4442", email: "Email: support@oloflix.tv");

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      SizedBox(height: 8.h),
      Text(phone, style: TextStyle(fontSize: 14.sp)),
      SizedBox(height: 4.h),
      Text(email, style: TextStyle(fontSize: 14.sp)),
    ],
  );
}