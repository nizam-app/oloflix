// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_jango/core/constants/color_control/all_color.dart';

// Project imports:
import 'package:market_jango/core/widget/aboute_fooder.dart';
import 'package:market_jango/core/widget/custom_home_topper_section.dart';
import 'package:market_jango/core/widget/custom_primium_button.dart';

class PpvScreen extends StatelessWidget {
  const PpvScreen({super.key});
  static final routeName = "/ppv_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              SizedBox(height: 20.h),
              _buildPayPerViewHeader(),
              SizedBox(height: 20.h),
              _buildPpvMovieList(),
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

/// Builds the grid list of Pay Per View movies.
///
/// This widget handles the layout and data for the movie posters.
Widget _buildPpvMovieList() {
  final List<String> images = [
    "assets/images/movie1.png",
    "assets/images/movie2.png",
    "assets/images/movie3.png",
    "assets/images/movie4.png",
    "assets/images/movie5.png",
  ];

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
    itemCount: images.length,
    itemBuilder: (context, index) {
      return _PpvMovieCard(image: images[index]);
    },
  );
}

/// A custom card widget to display a single movie poster with overlay text and an icon.
///
/// This widget includes the image, a gradient overlay with the movie title, and a crown icon.
class _PpvMovieCard extends StatelessWidget {
  final String image;
  const _PpvMovieCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r), // Use .r for responsive radius
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
                child: CustomPrimiumButton()),
            
          ],
        ),
      ),
    );
  }
}



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