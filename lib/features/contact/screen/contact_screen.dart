// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static final routeName = "/ContactScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              AbouteBackgrountImage(screenName: "Contact"),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Form
                    BuildContactFormField(label: "Name", hint: "Name"),
                    SizedBox(height: 16.h),
                    BuildContactFormField(label: "Email", hint: "Email"),
                    SizedBox(height: 16.h),
                    BuildContactFormField(
                        label: "Phone Number", hint: "Phone Number"),
                    SizedBox(height: 16.h),
                    BuildContactFormField(label: "Subject", hint: "Subject"),
                    SizedBox(height: 16.h),
                    BuildContactFormField(
                      label: "Your Message",
                      hint: "Your Message...",
                      maxLines: 5,
                    ),
                    SizedBox(height: 24.h),
                    // Submit Button
                    BuildSubmitButton(),
                    SizedBox(height: 24.h),
                    // Support Text
                    BuildSupportText(),
                    SizedBox(height: 32.h),
                    // Contact Information
                    BuildContactInformationSection.generalEnquiries(),
                    SizedBox(height: 24.h),
                    BuildContactInformationSection.salesAndSupport(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
              FooterSection()

            ],
          ),
        ),
      ),
    );
  }
}

//================================================================================================
// Custom Codebase
//================================================================================================

class BuildContactFormField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;

  const BuildContactFormField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AllColor.blue, width: 1.5),
            ),
            border:  OutlineInputBorder(
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: maxLines > 1 ? 16.h : 0,
              
            ),
          ),
          maxLines: maxLines,
        ),
      ],
    );
  }
}

class BuildSubmitButton extends StatelessWidget {
  const BuildSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},  style: ElevatedButton.styleFrom(
          backgroundColor: AllColor.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Text(
            "SUBMIT",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BuildSupportText extends StatelessWidget {
  const BuildSupportText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "We are available to support you! Just Fill The Form",
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class BuildContactInformationSection extends StatelessWidget {
  final String title;
  final String phone;
  final String email;

  const BuildContactInformationSection({
    super.key,
    required this.title,
    required this.phone,
    required this.email,
  });

  factory BuildContactInformationSection.generalEnquiries() {
    return const BuildContactInformationSection(
      title: "For General Enquiries:",
      phone: "Phone: +1 (416) 276-4403 | +234-904-444-4442",
      email: "Email: admin@oloflix.com",
    );
  }

  factory BuildContactInformationSection.salesAndSupport() {
    return const BuildContactInformationSection(
      title: "For Sales & Support:",
      phone: "Phone: +1 (416) 276-4403 | +234-904-444-4442",
      email: "Email: support@oloflix.com",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(phone, style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 4.h),
        Text(email, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }
}