// Flutter imports:
import 'package:Oloflix/core/widget/movie_and_promotion/custom_movie_card.dart';
import 'package:Oloflix/features/home/logic/cetarory_fiend_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';


class PpvScreen extends StatelessWidget {
  const PpvScreen({super.key});
  static final routeName = "/ppv_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              SizedBox(height: 20.h),
              _buildPayPerViewHeader(),
              SizedBox(height: 20.h),
              Consumer(
                builder: (context, ref, child) {
                  final ppv = ref.watch(CategoryFindController.PayPerViewFiendProvider("ppv"));

                  return ppv.when(
                    data: (movies) => _buildPpvMovieList(movies),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text("Error: $e"),
                  );
                },
              ),
            
              SizedBox(height: 60.h),
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- Custom Codebase ---------------------------

/// Builds the header section for the Pay Per View screen.
///
/// This widget contains a container with the "PAY PER VIEW MOVIES" title.
Widget _buildPayPerViewHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.grey, // Consider using AllColor for consistency
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "PAY PER VIEW MOVIES",
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

/// Builds the grid list of Pay Per View movies_music_video.
///
/// This widget handles the layout and data for the movie posters.
Widget _buildPpvMovieList(movies) {

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.all(10.r), // Use .r for responsive padding
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 15.w, // Use .w for responsive spacing
      mainAxisSpacing: 15.h, // Use .h for responsive spacing
      childAspectRatio: 0.75, // Adjust as needed for aspect ratio
    ),
    itemCount: movies.length,
    itemBuilder: (context, index) {
      final movie =movies[index] ;
      return CustomMoviCard(movie: movie);
    },
  );
}

/// A custom card widget to display a single movie poster with overlay text and an icon.

/// This widget includes the image, a gradient overlay with the movie title, and a crown icon.
// class _PpvMovieCard extends StatelessWidget {
//   final String image;
//   const _PpvMovieCard({super.key, required this.image});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r), // Use .r for responsive radius
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Positioned.fill(
//               child: Image.asset(image, fit: BoxFit.cover),
//             ),
//             Positioned(
//               top: 8.h,
//               right: 8.w,
//                 child: CustomPrimiumButton()),
//
//           ],
//         ),
//       ),
//     );
//   }
// }

// New Screen Example
class MovieDetails extends StatelessWidget {
  final String image;
  const MovieDetails({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movie Detail")),
      body: Center(child: Image.asset(image)),
    );
  }
}