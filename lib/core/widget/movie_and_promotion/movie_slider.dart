import 'package:Oloflix/core/constants/api_control/global_api.dart';
import 'package:Oloflix/core/utils/movies/go_to_details_screen.dart';
import 'package:Oloflix/core/utils/movies/slider_control.dart';
import 'package:Oloflix/features/movies_details/screen/movies_detail_screen.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class MovieSlider extends ConsumerWidget {


  MovieSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(SliderControl.sliderIndexProvider);
    final sliderData = ref.watch(SliderControl.sliderProvider);
    final currentIndexNotifier = ref.read(SliderControl.sliderIndexProvider.notifier);

    return sliderData.when(
      data: (sliders) {
        // If no sliders, show a message instead of crashing
        if (sliders.isEmpty) {
          return SizedBox(
            height: 200.h,
            child: Center(
              child: Text(
                "No banners available",
                style: TextStyle(color: AllColor.white70),
              ),
            ),
          );
        }

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: sliders.length,
              itemBuilder: (context, index, realIndex) {
                final slider = sliders[index];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.r),
                      child: Image.network(
                        "${api}${slider.image}", 
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200.h,
                        errorBuilder: (context, error, stackTrace) {
                          print("❌ Failed to load banner image: ${api}${slider.image}");
                          return Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: Icon(Icons.image_not_supported, 
                                color: Colors.white54, size: 50),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0.h,
                      left: 5.w,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // 👉 Watch বাটন Action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AllColor.amber,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.play_arrow),
                              GestureDetector(
                                onTap: () => goToDetailsScreen(context:context,id: slider.postId,),
                                  child: Text("Watch")),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              context.push(SubscriptionPlanScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AllColor.red,
                            ),
                            child: Row(
                              children: const [
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
                autoPlayInterval: const Duration(seconds: 5),
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  currentIndexNotifier.state = index;
                },
              ),
            ),

            const SizedBox(height: 12),

            // Dot Indicator (Reactive)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sliders.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentIndex == entry.key ? 30.0.w : 8.0.w,
                  height: 8.0.h,
                  margin: EdgeInsets.symmetric(horizontal: 8.0.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: currentIndex == entry.key
                        ? Colors.orange
                        : Colors.orange.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
      loading: () =>  Center(child: CircularProgressIndicator(color: AllColor.blue,)),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }
    
                      
     }
  void watch() {}

  void buyPlan() {}