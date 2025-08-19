import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/utils/movie_selaider_manage.dart';

class MovieSlider extends ConsumerWidget {
  final CarouselSliderController _controller = CarouselSliderController();

  final List<String> imageList = [
    'assets/images/movie1.jpg',
    'assets/images/movie2.jpg',
    'assets/images/movie3.jpg',
  ];

  MovieSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(sliderIndexProvider);
    final currentIndexNotifier = ref.read(sliderIndexProvider.notifier);
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: imageList.length,
          itemBuilder: (context, index, realIndex) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: Image.asset(
                    imageList[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 0.h,
                  left: 2.w,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AllColor.amber,
                        ),
                        child: Row(
                          children: [Icon(Icons.play_arrow), Text("Watch")],
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AllColor.red,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.workspace_premium),
                            Text("Buy Plan"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: 200.h,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              currentIndexNotifier.state = index;
            },
            scrollDirection: Axis.horizontal,
            reverse: false,
            enableInfiniteScroll: true,
          ),
        ),

        SizedBox(height: 12),
        // Dot Indicator (Reactive with Riverpod)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageList.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: currentIndex == entry.key ? 30.0.w : 8.0.w,
              height: 8.0.h,
              margin: EdgeInsets.symmetric(horizontal: 8.0.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: currentIndex == entry.key
                    ? Colors.orange
                    : Colors.orange.withOpacity(0.1.sp),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void watch() {}

  void buyPlan() {}
}