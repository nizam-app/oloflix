import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/features/home/widgets/aboute_fooder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static final routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xFF171029),
      body: SafeArea(
        child: SingleChildScrollView(
         // padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileTextImages(context),
              SizedBox(height: 20.h),
              customField(context, label: "Name", hint: "John Doe"),
              customField(context, label: "Email", hint: "example@gmail.com"),
              customField(context, label: "Password", hint: "12345678"),
              customField(context, label: "Phone", hint: "+880 1826344872"),
              customField(context, label: "Address", hint: "Dhaka, Bangladesh"),
              SizedBox(height: 10.h),
              imageUpload(),
               SizedBox(height: 10.h),
               FooterSection()

            ],

          ),
        ),
      ),
    );
  }

  Widget profileTextImages(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => context.push("/homePage"),
                  child: Text(
                    "Home",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_right, size: 20),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    context.push("/dashboard");
                  },
                  child: Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_right, size: 20),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                   // context.push("/profile");
                  },
                  child: Text(
                    "Edit Profile ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customField(
    BuildContext context, {
    required String label,
    required String hint,
  }) {
    return Padding(
      //padding: EdgeInsets.only(top: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1F1F1F),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget imageUpload() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile Image ",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h,), 
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Choose File..",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Container(
                   
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.red],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "BROWSE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[700],
          child: Icon(Icons.person, color: Colors.white),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text("UPDATE", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
