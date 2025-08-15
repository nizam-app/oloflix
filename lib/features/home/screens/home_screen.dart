// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:market_jango/core/constants/color_control/all_color.dart';
import 'package:market_jango/core/constants/color_control/theme_color_controller.dart';
import 'package:market_jango/core/constants/image_control/image_path.dart';
import 'package:market_jango/core/widget/aboute_fooder.dart';
import 'package:market_jango/core/widget/custom_home_topper_section.dart';
import 'package:market_jango/features/comedy/screen/shows_comedy_screen.dart';
import 'package:market_jango/features/home/logic/movie_selaider_manage.dart';
import 'package:market_jango/features/live/screen/live_screen.dart';
import 'package:market_jango/features/movies/screen/movies_screen.dart';
import 'package:market_jango/features/music_video/screen/music_video_screen.dart';
import 'package:market_jango/features/nollywood/screen/nollywood_screen.dart';
import 'package:market_jango/features/ppv/screen/ppv_screen.dart';
import 'package:market_jango/features/setting/screen/setting_screen.dart';
import 'package:market_jango/features/tv_shows/screen/tv_shows_screen.dart';

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

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: ThemeColorController.purpul),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Image.asset(ImagePath.logo, width: 200.w)],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Movies'),
            onTap: () => context.push(MoviesScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('TV Shows'),
            onTap: () => context.push(TvShowsScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.music_video_rounded),
            title: const Text('PPV'),
            onTap: () => context.push(PpvScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.live_tv),
            title: const Text('Live'),
            onTap: () => context.push(LiveScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.music_video),
            title: const Text('Music video'),
            onTap: () => context.push(MusicVideoScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.theater_comedy),
            title: const Text('Shows Comedy'),
            onTap: () => context.push(ShowsComedyScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Nollywood & African Movies'),
            onTap: () => context.push(NollywoodScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => context.push(SettingScreen.routeName),
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

class PromosionSlider extends ConsumerWidget {
  final CarouselSliderController _controller = CarouselSliderController();

  final List<String> imageList = [
    "assets/images/promotion.jpg",
    "assets/images/promotion1.jpeg",
    "assets/images/promotion2.jpg",
    "assets/images/promotion3.webp",
  ];

  PromosionSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Column(
        children: [
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: imageList.length,
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Image.asset(
                  imageList[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
            options: CarouselOptions(
              height: 100.h,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              enlargeCenterPage: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {},
              scrollDirection: Axis.horizontal,
              reverse: false,
              enableInfiniteScroll: true,
            ),
          ),

          SizedBox(height: 12),

          // Dot Indicator (Reactive with Riverpod)
        ],
      ),
    );
  }

  void watch() {}

  void buyPlan() {}
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
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                width: 180.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  image: DecorationImage(
                    image: AssetImage("assets/images/movie1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                // child: Image.asset("assets/images/movie1.jpg",fit: BoxFit.cover,)
              ),

              // PG 15+ top-right
              Positioned(
                top: 5,
                right: 10,
                child: Icon(
                  Icons.workspace_premium,
                  size: 28.sp,
                  color: AllColor.amber,
                ),
              ),

              // Left/Right Arrow
            ],
          );
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
