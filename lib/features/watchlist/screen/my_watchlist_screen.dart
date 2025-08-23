// Flutter imports:
import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/custom_movie_card.dart';
import 'package:Oloflix/features/watchlist/logic/watchlist_list_revarpot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

class MyWatchlistScreen extends StatelessWidget {
  const MyWatchlistScreen({super.key});
  static final routeName = "/myWatchlistScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              const AbouteBackgrountImage(screenName: "Dashboard  Screen"),
              WatchlistContent(),
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- Custom Codebase ---------------------------

/// The main content section for the user's watchlist page.
///
/// This widget combines the different watchlist categories.
class WatchlistContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoviesSection(),
          ShowsSection(),
          SportsSection(),
          LiveTVSection(),
        ],
      ),
    );
  }
}

/// Displays the "Movies" section with a list of movie posters.
class MoviesSection extends ConsumerWidget {
  const MoviesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(filteredWatchlistMoviesProvider);

    return movieAsync.when(
      data: (movie) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Movies"),
            SizedBox(height: 10.h),
           if (movie.length >= 0)
            CustomCard(movies: movie) // movies list pass করলাম
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
  

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20, // Keep as is, or use .sp if font scaling is desired
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMovieGrid() {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMoviePoster(),
          SizedBox(width: 16.w),
          _buildMoviePoster(),
        ],
      ),
    );
  }

  Widget _buildMoviePoster() {
    return Stack(
      children: [
        Container(
          width: 150.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            image: DecorationImage(
              image: AssetImage("assets/images/movie2.webp"), // Placeholder image
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.close, size: 16.sp, color: Colors.white),
            label: Text(
              "Remove",
              style: TextStyle(color: Colors.white, fontSize: 12.sp), // Example: Font size adjustment
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            ),
          ),
        ),
      ],
    );
  }
}
class CustomCard extends StatelessWidget {
  final List<MovieDetailsModel> movies; // 👉 movie লিস্ট নেবে

  const CustomCard({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return CustomMoviCard(movie: movie); // movie object পাঠাচ্ছি
        },
      ),
    );
  }
}

/// A generic section for displaying a category title.
class ShowsSection extends StatelessWidget {
  const ShowsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSectionTitle("Shows");
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0.h),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20, // Keep as is, or use .sp
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// A generic section for displaying a category title.
class SportsSection extends StatelessWidget {
  const SportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSectionTitle("Sports");
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0.h),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20, // Keep as is, or use .sp
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// A generic section for displaying a category title.
class LiveTVSection extends StatelessWidget {
  const LiveTVSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSectionTitle("Live TV");
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0.h),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20, // Keep as is, or use .sp
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}