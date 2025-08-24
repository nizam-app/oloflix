// Flutter imports:
import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/controller/bottom_controller.dart';
import 'package:Oloflix/core/widget/custom_category_name.dart';
import 'package:Oloflix/features/home/logic/cetarory_fiend_controller.dart';
import 'package:Oloflix/features/movies/screen/movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project imports:
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

import 'package:Oloflix/core/widget/movie_and_promotion/custom_movie_card.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/movie_slider.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/promosion_slider.dart';
import 'package:go_router/go_router.dart';
class HomeScreen extends ConsumerWidget {
  static final routeName = "/homePage";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example: তিনটা আলাদা category থেকে আলাদা data আনব
    final ppvMoviesAsync = ref.watch(CategoryFindController.categoryFiendProvider("17"));
    final nollywoodMoviesAsync = ref.watch(CategoryFindController.categoryFiendProvider("2"));
    final musicMoviesAsync = ref.watch(CategoryFindController.categoryFiendProvider("12"));
    final talkShows = ref.watch(CategoryFindController.categoryFiendProvider("15"));

    return Scaffold(
      endDrawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHomeTopperSection(),
              MovieSlider(),
              PPVNoticeSection(),
              PromosionSlider(),

              // PPV Movies
              CustomCategoryName(
                context: context,
                text: "Pay-Per-View Movies (PPV)",
                onPressed: () => goToPPVScreen(   ref
                ),
              ),
              ppvMoviesAsync.when(
                data: (movies) => CustomCard(movies: movies,),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error: $e"),
              ),

              // Nollywood Movies
              CustomCategoryName(
                context: context,
                text: "Nollywood & African Movies",
                onPressed: () => goToNollywoodScreen(context),
              ),
              nollywoodMoviesAsync.when(
                data: (movies) => CustomCard(movies: movies,),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error: $e"),
              ),

              // Music Videos

              CustomCategoryName(
                context: context,
                text: "Talk Shows & Podcasts",
                onPressed: () => goToTalkVideoScreen(context),
              ),
              talkShows.when(
                data: (movies) => CustomCard(movies: movies,),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error: $e"),
              ),
              CustomCategoryName(
                context: context,
                text: "Music Video",
                onPressed: () => goToMosicVideoScreen(context),
              ),
              musicMoviesAsync.when(
                data: (movies) => CustomCard(movies: movies, ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error: $e"),
              ),

              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  void goToPPVScreen(WidgetRef ref) {
           goToPPvScreen(ref) ;
    
  }
  void goToNollywoodScreen(BuildContext context) {
    context.push("${MoviesScreen.routeName}/2");
  }
  void goToMosicVideoScreen(BuildContext context) {
    context.push("${MoviesScreen.routeName}/12");
  }
  void goToTalkVideoScreen(BuildContext context) {
    context.push("${MoviesScreen.routeName}/15");
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




class PPVNoticeSection extends StatelessWidget {
  const PPVNoticeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        "We are Glad to announce that our PAY-PER-VIEW movies are now available. These Premium Movies are highly curated and are independent of your current subscription plan. You're required to Pay and View each movies separately. Click on any PPV movies to view its cost and access period",
        style: TextStyle(color: AllColor.white70),
      ),
    );
  }
}

class SponsorBanner extends StatelessWidget {
  const SponsorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'AXTRAB TECHNOLOGY LTD.',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            'The Energy Solution\nTEL: 0**********, 0*********',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class RecentlyWatchedSection extends StatelessWidget {
  const RecentlyWatchedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return buildHorizontalList(
      title: 'Recently Watched',
      images: [
        'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg',
        'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg',
      ],
    );
  }
}

class PPVMoviesSection extends StatelessWidget {
  const PPVMoviesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return buildHorizontalList(
      title: 'Pay-Per-View Movies (PPV)',
      images: [
        'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg',
        'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg',
      ],
    );
  }
}

Widget buildHorizontalList({
  required String title,
  required List<String> images,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Image.network(images[index]),
            );
          },
        ),
      ),
    ],
  );
}

BottomNavigationBar buildBottomNavigationBar() {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.white,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'PPV'),
      BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Account',
      ),
    ],
  );
}