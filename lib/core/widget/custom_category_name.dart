import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCategoryName extends StatelessWidget {
  const CustomCategoryName({
    super.key,
    required this.context,
    required this.text,
    required this.onPressed,
  });

  final BuildContext context;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(text, style: Theme.of(context).textTheme.titleLarge),
              Spacer(),
              TextButton(
                onPressed: onPressed,
                child: Text(
                  "See All",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}