// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
// Logic (Controller -> repo auto adds "Authorization: Bearer <token>")
import 'package:Oloflix/features/contact/logic/contract_reverpot.dart';

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
  void dispose() {
    _name.dispose(); _email.dispose(); _phone.dispose();
    _subject.dispose(); _msg.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_key.currentState?.validate() ?? false)) return;
    try {
      await ref.read(contactControllerProvider.notifier).submit(
        name: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        subject: _subject.text.trim(),
        message: _msg.text.trim(),
      );
      if (!mounted) return;
      _name.clear(); _email.clear(); _phone.clear(); _subject.clear(); _msg.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Your message was sent.'), backgroundColor: AllColor.green500),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactControllerProvider);
    final loading = state.isLoading;

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
                  _Field(label: "Name", hint: "Name", controller: _name,
                      validator: (v)=> (v==null||v.trim().isEmpty)?'Enter name':null),
                  SizedBox(height: 16.h),
                  _Field(label: "Email", hint: "Email", controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v)=> (v==null||!v.contains('@'))?'Enter valid email':null),
                  SizedBox(height: 16.h),
                  _Field(label: "Phone Number", hint: "Phone Number",
                      controller: _phone, keyboardType: TextInputType.phone),
                  SizedBox(height: 16.h),
                  _Field(label: "Subject", hint: "Subject",
                      controller: _subject, validator: (v)=> (v==null||v.trim().isEmpty)?'Enter subject':null),
                  SizedBox(height: 16.h),
                  _Field(label: "Your Message", hint: "Your Message...",
                      controller: _msg, maxLines: 5,
                      validator: (v)=> (v==null||v.trim().isEmpty)?'Enter message':null),
                  SizedBox(height: 24.h),

                  // Submit button with loading
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AllColor.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: loading
                          ? SizedBox(height: 20.r, width: 20.r,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AllColor.white))
                          : Text("SUBMIT", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  SizedBox(height: 24.h),
                  const _SupportText(),
                  SizedBox(height: 32.h),
                  const _InfoSection(
                    title: "For General Enquiries:",
                    phone: "Phone: +1 (416) 276-4403 | +234-904-444-4442",
                    email: "Email: admin@oloflix.tv",
                  ),
                  SizedBox(height: 24.h),
                  const _InfoSection(
                    title: "For Sales & Support:",
                    phone: "Phone: +1 (416) 276-4403 | +234-904-444-4442",
                    email: "Email: support@oloflix.tv",
                  ),
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

/* ============ small, reusable widgets (short) ============ */

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  final String label, hint;
  final int maxLines;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

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
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AllColor.blue, width: 1.5)),
          border: const OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: maxLines > 1 ? 16.h : 0),
        ),
      ),
    ],
  );
}

class _SupportText extends StatelessWidget {
  const _SupportText();

  @override
  Widget build(BuildContext context) => Text(
    "We are available to support you! Just Fill The Form",
    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
    textAlign: TextAlign.center,
  );
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.phone, required this.email});
  final String title, phone, email;

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