// Flutter imports:
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/app_drawer.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

import 'package:Oloflix/core/widget/movie_and_promotion/custom_movie_card.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/movie_slider.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/promosion_slider.dart';
class HomeScreen extends StatelessWidget {
  static final routeName = "/homePage";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              buildLIstName(
                context: context,
                text: "Pay-Per-View Movies (PPV)",
                onPressed: () {
                  goToPPVScreen();
                },
              ),
              CustomCard(),
              buildLIstName(
                context: context,
                text: "Nollywood & African Movies",
                onPressed: () {
                  goToNollywoodScreen();
                },
              ),
              CustomCard(),
              buildLIstName(
                context: context,
                text: "Music Video",
                onPressed: () {
                  goToMosicVideoScreen();
                },
              ),
              CustomCard(),
              buildLIstName(
                context: context,
                text: "Talk Shows & Podcasts",
                onPressed: () {
                  goToMosicVideoScreen();
                },
              ),
              CustomCard(),
              FooterSection(),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  void goToPPVScreen() {}

  void goToNollywoodScreen() {}

  void goToMosicVideoScreen() {}

  Padding buildLIstName({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(text, style: Theme.of(context).textTheme.titleLarge),
              Spacer(),
              TextButton(
                onPressed: onPressed,
                child: Text(
                  "See All",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class CustomSearchDelegate extends SearchDelegate {
  final List<String> searchList;

  CustomSearchDelegate(this.searchList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchList
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(results[index]),
        onTap: () {
          close(context, results[index]);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchList
        .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestions[index]),
        onTap: () {
          query = suggestions[index];
          showResults(context);
        },
      ),
    );
  }
}


class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return CustomMoviCard();
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
        "We are Glad to announce that our PAY-PER-VIEW movies_music_video are now available. These Premium Movies are highly curated and are independent of your current subscription plan. You're required to Pay and View each movies_music_video separately. Click on any PPV movies_music_video to view its cost and access period",
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