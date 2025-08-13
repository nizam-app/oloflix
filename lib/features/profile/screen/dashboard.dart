import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/features/home/widgets/aboute_fooder.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static final routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dashboardTextImages(context),
              SizedBox(height: 20.h),
              dashboardDeailsn(),
              SizedBox(height: 20.h),
              userHistory(),
              FooterSection(),
              
              

            ],
          ),
        ),
      ),
    );
  }
}

Widget dashboardTextImages(BuildContext context) {
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
            "Dashboard",
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
                 // context.push("/dashboard");
                },
                child: Text(
                  "Dashboard",
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

Widget dashboardDeailsn() {
  return Column(
    children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
        decoration: BoxDecoration(
          color: Color(0xFF171029),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[700],
              child: Icon(Icons.person, color: Colors.white, size: 60),
            ),
            SizedBox(height: 16.h),
            Text(
              "Palash Roy",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "palashtpi21@gmail.com",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              width: 90,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit_square, size: 16, color: Colors.white),
                  SizedBox(width: 5.w),
                  Text("EDIT", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              width: 180.w,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.white),
                  SizedBox(width: 5),
                  Text("ACCOUTN DELETE", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            Container(
              height: 150,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
              decoration: BoxDecoration(
              color: Color.fromARGB(255, 119, 93, 184),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.w,
                ),
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Subscription",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(height: 2, width: 40, color: Colors.red),
                    SizedBox(height: 16.h),
                    Container(
                      width: 120.w,
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
                        "SELECT PLAN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

           SizedBox(height: 10.h,),
           Container(
              height: 180,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
              decoration: BoxDecoration(
              color: Color.fromARGB(255, 119, 93, 184),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.w,
                ),
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Invoice",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(height: 2, width: 40, color: Colors.red),
                    SizedBox(height: 20.h),
                    Text(
                      "Date:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Plan:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Amount:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    ],
  );
}

Widget userHistory() {
      List<String> headers = [
  "Plan",
  "Amount",
  "Payment Gateway",
  "Payment ID",
  "Payment Date"
];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
            Text(
              "User History",
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
  

Container(
  height: 60.h,
  width: double.infinity,
  decoration: BoxDecoration(
    color: Color.fromARGB(255, 119, 93, 184),
    borderRadius: BorderRadius.circular(8),
  ),
  child: ListView.builder(
    scrollDirection: Axis.horizontal, 
    itemCount: headers.length,
    itemBuilder: (context, index) {
      return InkWell(
        onTap: () {
          
          
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Text(
              headers[index],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
          ),
        ),
      );
    },
  ),
),  

    ],
  );
}
