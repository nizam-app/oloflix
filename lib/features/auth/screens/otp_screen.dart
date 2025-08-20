import 'package:Oloflix/features/auth/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  static final routeName = '/otp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              _TitleText(),
              SizedBox(height: 60),
                 OTPPin(),
              SizedBox(height: 30),
              CustomButtom(
                text: "NEXT",
                onTap: () {
                  context.push('/reset_password');
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Send OTP",
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}


class OTPPin extends StatelessWidget {
  const OTPPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PinCodeTextField(
            appContext: context,
            length: 6,
            onChanged: (value) {},
            onCompleted: (code) {
              print("OTP Entered: $code");
            },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 52.h,
              fieldWidth: 44.w,
              activeFillColor: Colors.grey,
              inactiveFillColor: Colors.grey,
              selectedFillColor: Colors.grey,
              activeColor: Colors.transparent,
              inactiveColor: Colors.transparent,
              selectedColor: Colors.transparent,
            ),
            keyboardType: TextInputType.number,
            enableActiveFill: true,
          ),
          SizedBox(height: 50.h), // Reduced height for better layout
        ],
      ),
    );
  }
}
