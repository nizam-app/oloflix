import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromosionSlider extends ConsumerWidget {
  final CarouselSliderController _controller = CarouselSliderController();

  final List<String> imageList = [
    "assets/images/promotion.jpg",
    "assets/images/promotion1.jpeg",
    "assets/images/promotion2.jpg",
    "assets/images/promotion3.webp",
  ];

  PromosionSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Column(
        children: [
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: imageList.length,
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Image.asset(
                  imageList[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
            options: CarouselOptions(
              height: 100.h,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              enlargeCenterPage: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {},
              scrollDirection: Axis.horizontal,
              reverse: false,
              enableInfiniteScroll: true,
            ),
          ),

          SizedBox(height: 12),

          // Dot Indicator (Reactive with Riverpod)
        ],
      ),
    );
  }

  void watch() {}

  void buyPlan() {}
}