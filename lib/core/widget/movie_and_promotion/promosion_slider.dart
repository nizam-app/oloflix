// lib/core/widget/movie_and_promotion/promosion_slider.dart
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logic/promosion_revarpod.dart';

class PromosionSlider extends ConsumerWidget {
  PromosionSlider({super.key});

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsAsync = ref.watch(adsProvider);
    final currentIndex = ref.watch(adsSliderIndexProvider);
//update
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Column(
        children: [
          adsAsync.when(
            loading: () => SizedBox(
              height: 100.h,
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SizedBox(
              height: 100.h,
              child: Center(child: Text("Ads error: $e", style: const TextStyle(color: Colors.white))),
            ),
            data: (ads) {
              if (ads.isEmpty) {
                // টোকেন নাই/ডেটা নাই হলে fallback (ইচ্ছা হলে hide করতে পারো)
                return SizedBox(
                  height: 110.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child: Image.asset("assets/images/promotion.jpg",
                        fit: BoxFit.cover,
                      width: double.infinity
                    ),
                  ),
                );
              }

              final repo = ref.read(adsRepoProvider); // full image url বানাতে

              return Column(
                children: [
                  CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: ads.length,
                    itemBuilder: (context, index, realIdx) {
                      final ad = ads[index];
                      final fullImg = repo.toFullUrl(ad.image);

                      return GestureDetector(
                        onTap: () async {
                          final url = ad.url?.trim();
                          if (url != null && url.isNotEmpty) {
                            final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.network(
                            fullImg,
                          //  fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.black12,
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_not_supported, color: Colors.white70),
                            ),
                            loadingBuilder: (c, w, p) {
                              if (p == null) return w;
                              return Container(
                                color: Colors.black12,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                       height: 120.h,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      enlargeCenterPage: false,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      onPageChanged: (idx, reason) {
                        ref.read(adsSliderIndexProvider.notifier).state = idx;
                      },
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Dot indicator (simple)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(ads.length, (i) {
                      final active = i == currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        width: active ? 14.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: active ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}