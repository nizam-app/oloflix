// lib/features/movies_details/movies_detail_screen.dart
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/core/constants/api_control/global_api.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/base_widget_tupper_botton.dart';
import 'package:Oloflix/core/widget/custom_category_name.dart';
import 'package:Oloflix/core/widget/custom_snackbar.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/custom_movie_card.dart';
import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:Oloflix/features/deshboard/model/deshboard_model.dart';
import 'package:Oloflix/features/movies_details/logic/get_movie_details.dart';
import 'package:Oloflix/features/movies_details/logic/related_movie_show_revarpod.dart';
import 'package:Oloflix/features/profile/logic/login_check.dart';
import 'package:Oloflix/features/subscription/screen/ppv_subscription.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:Oloflix/features/video_show/video_show_screen.dart';
import 'package:Oloflix/features/watchlist/logic/watchlist_add_revarpot.dart';
import 'package:Oloflix/features/watchlist/logic/watchlist_list_revarpot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../deshboard/logic/deshboard_reverport.dart';

/// --------------------
/// Helpers
/// --------------------
String? formatReleaseDate(dynamic raw) {
  if (raw == null) return null;
  final s = raw.toString().trim();
  if (s.isEmpty || s == '0' || s.toLowerCase() == 'null') return null;

  final n = int.tryParse(s);
  if (n != null) {
    final dt = n > 2000000000
        ? DateTime.fromMillisecondsSinceEpoch(n)
        : DateTime.fromMillisecondsSinceEpoch(n * 1000);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  try {
    return DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(s));
  } catch (_) {
    return null;
  }
}

bool hasText(String? v) =>
    v != null && v.trim().isNotEmpty && v.toLowerCase() != 'null';

void playVideoRoute(BuildContext context, String url) {
  context.push("${VideoShowScreen.routeName}?url=$url");
}

/// --------------------
/// Screen
/// --------------------
class MoviesDetailScreen extends ConsumerWidget {
  const MoviesDetailScreen({super.key, required this.id});
  final int id;

  static const String routeName = '/moviesDetailScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(MovieDetailsController.movieByIdProvider(id));

    return movieAsync.when(
      data: (movie) {
        if (movie == null) {
          return const Scaffold(
            body: Center(child: Text("Movie not found")),
          );
        }

        // Access flags
        final String checkPaid = (movie.videoAccess ?? 'free').toString();
        final bool isPpv = checkPaid.toLowerCase() == 'ppv';
        final int movieId = movie.id ?? 0;
        final String videoUrl = movie.videoUrl ?? '';

        // Trailer URL (supports different possible keys)
        final String trailerUrl =
        (movie.trailerUrl ?? movie.trailerUrl?? '').toString();

        // Related movies
        final relatedAsync = ref.watch(
          relatedMoviesProvider((slug: movie.videoSlug ?? '', id: movieId)),
        );

        return BaseWidgetTupperBotton(
          child1: DetailsImage(
            imageUrl: "$api${movie.videoImage}",
            date: movie.releaseDate,
            duration: movie.duration ?? "",
            videoUrl: videoUrl,
            checkPaid: checkPaid,
            postID: movieId,
            isPpv: isPpv,
            movieId: movieId,
            videoSlug:movie.videoSlug,
          ),
          child2: Column(
            children: [
              CustomDescription(
                title: movie.videoTitle ?? '',
                language: "English",
                age: '18+',
                description: movie.videoDescription ?? '',
                trailerUrl: trailerUrl, // ← trailer play hook
              ),
              CustomCategoryName(
                context: context,
                text: "You May Also Like",
                onPressed: () {},
              ),
              relatedAsync.when(
                data: (movies) => CustomCard(movies: movies),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Error: $e"),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),
    );
  }
}

/// --------------------
/// Description section
/// --------------------
class CustomDescription extends StatelessWidget {
  const CustomDescription({
    super.key,
    required this.title,
    required this.language,
    required this.age,
    required this.description,
    required this.trailerUrl,
  });

  final String title;
  final String language;
  final String age;
  final String description;
  final String trailerUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text(
              language,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                age,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // 🎬 Watch Trailer
        CustomElevatedbutton(
          title: 'Watch Trailer',
          color: AllColor.orange,
          onPressed: () {
            if (hasText(trailerUrl)) {
              playVideoRoute(context, trailerUrl);
            } else {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  const SnackBar(content: Text('Trailer not available')),
                );
            }
          },
        ),

        if (hasText(description))
          Html(data: description)
        else
          const SizedBox.shrink(),
        SizedBox(height: 20.h),
      ],
    );
  }
}

/// --------------------
/// Poster + meta + buttons
/// --------------------
class DetailsImage extends ConsumerWidget {
  const DetailsImage({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.duration,
    required this.videoUrl,
    required this.checkPaid,
    required this.postID,
    required this.isPpv,
    required this.movieId,
    required this.videoSlug
  });

  final String imageUrl;
  final dynamic date; // int/string/iso/null—সবই allow
  final String duration;
  final String videoUrl;
  final String checkPaid;
  final int postID;

  final bool isPpv;   // from parent (derived from videoAccess)
  final int movieId;  // from parent
  final dynamic videoSlug ;

  static Set<int> premiumPlanIds = {8, 12};
  bool hasPremium(User? u) => u != null && premiumPlanIds.contains(u.planId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prettyDate = formatReleaseDate(date);
    final showDuration = hasText(duration);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.h,
          ),
        ),

        // ▶️ Play Button
        Positioned(
          right: 8.w,
          top: 8.h,
          child: InkWell(
            onTap: () => videoPlayButtonLogic(
              context,
              ref,
              checkPaid: checkPaid,
              isPpv: isPpv,
              movieId: movieId,
              videoUrl: videoUrl,
              videoSlug: videoSlug
            ),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.red,
              child: Icon(Icons.play_arrow, color: Colors.white, size: 20.sp),
            ),
          ),
        ),

        // 📅 Date + ⏱ Duration
        Positioned(
          bottom: 48.h,
          left: 3.w,
          child: Row(
            children: [
              if (prettyDate != null) ...[
                Icon(FontAwesomeIcons.solidCalendarDays,
                    size: 16.sp, color: Colors.white),
                SizedBox(width: 6.w),
                Text(
                  prettyDate,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16.w),
              ],
              if (showDuration)
                Row(
                  children: [
                    Icon(FontAwesomeIcons.clock, size: 16.sp, color: Colors.white),
                    SizedBox(width: 6.w),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Buttons bottom
        Positioned(
          bottom: 3.h,
          left: 3.w,
          right: 3.w,
          child: Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
                onPressed: () async {
                  try {
                    await ref
                        .read(watchlistAddControllerProvider.notifier)
                        .addMovie(AuthAPIController.addWatchlist, postID, "Movies");

                    ref.invalidate(watchlistProvider);
                    ref.invalidate(filteredWatchlistMoviesProvider);

                    if (context.mounted) {
                      showCustomSnackBar(
                        context,
                        message: "Added to Watchlist",
                        bgColor: Colors.green,
                        icon: Icons.check_circle,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showCustomSnackBar(
                        context,
                        message: "Failed: $e",
                        bgColor: Colors.red,
                        icon: Icons.error_outline,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  }
                },
                icon: Icon(Icons.add, color: Colors.white, size: 18.sp),
                label: Text(
                  "Add to Watchlist",
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              ),
              SizedBox(width: 12.w),
              CustomElevatedbutton(
                title: 'Watch',
                color: AllColor.blue,
                onPressed: () => videoPlayButtonLogic(
                  context,
                  ref,
                  checkPaid: checkPaid,
                  isPpv: isPpv,
                  movieId: movieId,
                  videoUrl: videoUrl,
                  videoSlug:      videoSlug
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> videoPlayButtonLogic(
      BuildContext context,
      WidgetRef ref, {
        required String checkPaid,     // "Paid" / "Free" (string)
        required bool isPpv,           // এই ভিডিও PPV নাকি
        required int movieId,          // PPV হলে দরকার
        required String? videoUrl,     // প্লে লিংক
        required String videoSlug,     // PPV API hit-এর জন্য
      }) async {
    // 🔐 Login check
    final loggedIn = await AuthHelper.isLoggedIn();
    if (!loggedIn) {
      if (context.mounted) context.push(LoginScreen.routeName);
      return;
    }

    final user = ref.read(userProvider);
    final bool hasSub = hasPremium(user); // ✅ তোমার আগের ফাংশন

    // 🎬 helper: play or show error
    Future<void> _play(String? url) async {
      if (url != null && url.trim().isNotEmpty) {
        playVideoRoute(context, url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(content: Text("Video URL not found")));
        }
      }
    }

    // 🧾 helper: PPV access check (slug + id + token)
    Future<bool> _ppvAccessCheck() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';
        final url = "${AuthAPIController.movies_watch_ppv}/$videoSlug/$movieId";

        final res = await http.get(
          Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            if (token.isNotEmpty) 'Authorization': 'Bearer $token',
          },
        );
        return res.statusCode == 200;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Network error: $e')));
        }
        return false;
      }
    }

    // =========================
    //        MAIN LOGIC
    // =========================

    // 1) Subscription আছে → সব ভিডিও প্লে (PPV-তেও কোনো অতিরিক্ত চেক না)
    if (hasSub) {
      await _play(videoUrl);
      return;
    }

    // 2) Subscription নেই → যদি PPV হয়, তাহলে অ্যাক্সেস চেক
    if (isPpv) {
      final ok = await _ppvAccessCheck();
      if (ok) {
        await _play(videoUrl);
      } else {
        if (context.mounted) {
          context.push(
            PPVSubscriptionPlanScreen.routeName,
            extra: {'movieId': movieId},
          );
        }
      }
      return;
    }

    // 3) Subscription নেই & PPV নয় → Paid হলে সাবস্ক্রিপশন চাইবে
    final bool contentNeedsPaid = checkPaid.toLowerCase() == 'paid';
    if (contentNeedsPaid) {
      if (context.mounted) {
        context.push(SubscriptionPlanScreen.routeName);
      }
      return;
    }

    // 4) Free কনটেন্ট → প্লে
    await _play(videoUrl);
  }



}

/// --------------------
/// Small button widget
/// --------------------
class CustomElevatedbutton extends StatelessWidget {
  const CustomElevatedbutton({
    super.key,
    required this.title,
    required this.color,
    this.onPressed,
  });

  final String title;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: AllColor.white, fontSize: 13.sp),
      ),
    );
  }
}

/// --------------------
/// Related movie list
/// --------------------
class CustomCard extends ConsumerWidget {
  const CustomCard({super.key, required this.movies});
  final List<dynamic> movies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return CustomMoviCard(movie: movie);
        },
      ),
    );
  }
}