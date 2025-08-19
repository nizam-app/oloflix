// Flutter imports:
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';

// Project imports:
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/custom_movie_card.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/move_fildering.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/movie_slider.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/promosion_slider.dart';



class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  static final String routeName = "/moviesScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               CustomHomeTopperSection(),
               MovieSlider(),
              SizedBox(height: 16.h), // Add some spacing
              const FilterDropdownSection(),
              // <-- Add this new custom widget call
              SizedBox(height: 16.h),
              PromosionSlider(),
              SizedBox(height: 16.h), // Add some spacing
              // Add some spacing
              const _CustomMovieGrid(), // <-- Add this custom widget
              SizedBox(height: 16.h), // Add some spacing
              // Footer section if needed
              PaginationExample(), // Uncomment if you have pagination
              FooterSection(), // Uncomment if you have a footer section
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- Custom Codebase ---------------------------

/// A StatefulWidget that builds the filter section with dropdowns.


/// Builds a static filter button (like the "MOVIES" button).


// (Add this below _buildStaticFilterButton in the Custom Codebase section)

/// A custom dropdown button widget used for filtering.
/// It takes a label, a list of items, and a callback for when an item is selected.


/// A custom widget to display a grid of movie cards.
class _CustomMovieGrid extends StatelessWidget {
  const _CustomMovieGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       // Assuming PromosionSlider should be above the grid
        GridView.builder(
          shrinkWrap: true, // Important: Allow GridView to size itself based on content
          physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            childAspectRatio: 0.99, // Adjust as needed for card aspect ratio
            crossAxisSpacing: 0.w,
            mainAxisSpacing: 10.h,
          ),
          itemCount: 10, // Replace with your actual item count
          itemBuilder: (context, index) => const CustomMoviCard(),
        ),
      ],
    );
  }
}
class PaginationExample extends StatefulWidget {
  @override
  _PaginationExampleState createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h, // Adjust height as needed
      child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Previous Button
              _buildCircleButton(
                icon: Icons.arrow_left,
                onTap: () {
                  if (currentPage > 1) {
                    setState(() => currentPage--);
                  }
                },
              ),

              const SizedBox(width: 8),

              // Page Numbers
              for (int i = 1; i <= 3; i++) ...[
                _buildPageNumber(i),
                const SizedBox(width: 8),
              ],

              // Next Button
              _buildCircleButton(
                icon: Icons.arrow_right,
                onTap: () {
                  if (currentPage < 3) {
                    setState(() => currentPage++);
                  }
                },
              ),
            ],
          ),
        ),
    );
  }

  // Circle button for arrows
  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // Page Number Button
  Widget _buildPageNumber(int page) {
    bool isActive = page == currentPage;
    return InkWell(
      onTap: () {
        setState(() => currentPage = page);
      },
      borderRadius: BorderRadius.circular(50),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: isActive ? Colors.redAccent : Colors.white,
        child: Text(
          "$page",
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}