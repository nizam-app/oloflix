import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/core/constants/color_control/all_color.dart';
import 'package:market_jango/core/constants/color_control/theme_color_controller.dart';
import 'package:market_jango/core/constants/image_control/image_path.dart';
import 'package:market_jango/core/theme/logic/theme_changer.dart';
import 'package:market_jango/features/comedy/screen/shows_comedy_screen.dart';
import 'package:market_jango/features/home/logic/movie_selaider_manage.dart';
import 'package:market_jango/features/home/screens/dashboard_screen.dart';
import 'package:market_jango/features/home/screens/my_watchlist_screen.dart';
import 'package:market_jango/features/home/screens/profile_screeen.dart';
import 'package:market_jango/features/home/screens/subscription_plan_screen.dart';
import 'package:market_jango/features/live/screen/live_screen.dart';
import 'package:market_jango/features/movies/screen/movies_screen.dart';
import 'package:market_jango/features/music_video/screen/music_video_screen.dart';
import 'package:market_jango/features/nollywood/screen/nollywood_screen.dart';
import 'package:market_jango/features/ppv/screen/ppv_screen.dart';
import 'package:market_jango/features/setting/screen/setting_screen.dart';
import 'package:market_jango/features/tv_shows/screen/tv_shows_screen.dart';

class HomeScreen extends StatelessWidget {
  static final routeName ="/homePage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      endDrawer: AppDrawer(),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopperLogo(),
              MovieSlider(),
              PPVNoticeSection(),
              SponsorBanner(),
              buildLIstName(context: context, text: "Pay-Per-View Movies (PPV)",
                  onPressed: (){goToPPVScreen();}),
              CustomCard(),
              buildLIstName(context: context, text: "Nollywood & African Movies",
                  onPressed: (){goToNollywoodScreen();}),
              CustomCard(),
              buildLIstName(context: context, text: "Music Video",
                  onPressed: (){goToMosicVideoScreen();}),
              CustomCard(),
              buildLIstName(context: context, text: "Talk Shows & Podcasts",
                  onPressed: (){goToMosicVideoScreen();}),
              CustomCard()


            ],
          ),
        ),
      ),
      //bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
  void goToPPVScreen(){
  }
  void goToNollywoodScreen(){}
  void goToMosicVideoScreen (){}

  Padding buildLIstName({required BuildContext context, required String text, required VoidCallback onPressed}) {
    return Padding(
              padding:  EdgeInsets.all(8.0.sp),
              child: Column(
                children: [
                  SizedBox(height: 10.h,),
                  Row(
                    children: [
                      Text(text,style: Theme.of(context).textTheme.titleLarge,),
                      Spacer(),
                      TextButton(onPressed: onPressed, child: Text("See All",style: Theme.of(context).textTheme.titleMedium))
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
            decoration:  BoxDecoration(
              color: ThemeColorController.purpul,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                Image.asset(ImagePath.logo, width: 200.w,),
                ],
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
          ),ListTile(
            leading: const Icon(Icons.live_tv),
            title: const Text('Live'),
            onTap: () => context.push(LiveScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.music_video),
            title: const Text('Music video'),
            onTap: () => context.push(MusicVideoScreen.routeName),
          ), ListTile(
            leading: const Icon(Icons.theater_comedy),
            title: const Text('Shows Comedy'),
            onTap: () => context.push(ShowsComedyScreen.routeName),
          ), ListTile(
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

class CustomTopperLogo extends StatelessWidget {
   CustomTopperLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset("${ImagePath.logo}",
            width: 80.w,),
            Spacer(),
            InkWell(
              onTap: (){
                goToSearch(context);
              },
              child: CircleAvatar(
                radius: 14.r,
                  backgroundColor: AllColor.red,
                  child: Icon(Icons.search,color: ThemeColorController.white,)),
            ),
            SizedBox(width: 20.w),
            InkWell(
              onTap: (){goToSubscriptionScreen(context);},
              child: Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                  color: AllColor.amber,
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),),

                  child: Icon(Icons.workspace_premium), ),
            ),
            // Crown
            SizedBox(width: 5.w),
            _UserMenu(menuItems: menuItems),

            IconButton(
              icon:  Icon(Icons.menu_rounded, color: Colors.white, size: 24.sp),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
            SizedBox(width: 5.w),
          ],
        ),
        SizedBox(height: 20.h,)
      ],

    );
  }
   final List<_MenuItem> menuItems = [
     _MenuItem('Dashboard', Icons.storage),
     _MenuItem('Profile', Icons.person),
     _MenuItem('My Watchlist', Icons.list_alt),
     _MenuItem('Logout', Icons.logout),
   ];
  final List<String> items = [
    'Apple',
    'Banana',
    'Mango',
    'Orange',
    'Pineapple',
    'Watermelon',
    'Grapes',
    'Strawberry'
  ];
 void goToSearch(BuildContext context){
    showSearch(context: context, delegate: CustomSearchDelegate(items));
  }
  void goToSubscriptionScreen(BuildContext context){
   context.push(SubscriptionPlanScreen.routeName);
  }

}
class _UserMenu extends StatelessWidget {
  final List<_MenuItem> menuItems;

  const _UserMenu({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    final ThemeChanger _themeController = Get.put(ThemeChanger());
    return PopupMenuButton<int>(
      icon: Stack(
        children: [
          Icon(Icons.person, size: 24.sp,),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: ThemeColorController.green,
                shape: BoxShape.circle,
                border: Border.all(color: ThemeColorController.white, width: 1.w),
              ),
            ),
          )
        ],
      ),
      itemBuilder: (context) => List.generate(
        menuItems.length,
            (index) => PopupMenuItem<int>(
          value: index,
          child: Row(
            children: [
              Icon(menuItems[index].icon,color:Theme.of(context).colorScheme.onPrimary,),
               SizedBox(width: 10.w),
              Text(menuItems[index].title),
            ],
          ),
        ),
      ),
      onSelected: (index) {
       goToNextPage(index, context);
      },
    );
  }
  void goToNextPage(int index, BuildContext context){
    if(index == 0){
      context.push(DashboardScreen.routeName);
    }
    else if(index == 1){

      context.push(ProfileScreen.routeName);
    }
    else if(index == 2){
      context.push(MyWatchlistScreen.routeName);
    }
    else if(index == 3){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("LogOut"),
            content: Text("Are you sure you want to LogOut ?"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AllColor.red,
                ),
                onPressed: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(" LogOut Done")),
                  );
                },
                child: const Text("LogOut"),
              ),
            ],
          );
        },
      );
    }
  }
}

class _MenuItem {
  final String title;
  final IconData icon;

  _MenuItem(this.title, this.icon);
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
        )
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentIndex = ref.watch(sliderIndexProvider);
    final _currentIndexNotifier = ref.read(sliderIndexProvider.notifier);
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
                  bottom: 0,
                  left: 2,
                  child: Row(
                    children: [
                     ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: AllColor.amber), child: Row(children: [
                      Icon(Icons.play_arrow),
                       Text("Watch"),
                     ],)),
                      SizedBox(width: 10),
                      ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: AllColor.red), child: Row(children: [
                        Icon(Icons.workspace_premium),
                        Text("Buy Plan"),
                      ],)),

                    ],
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: 200.h,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 10),
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              _currentIndexNotifier.state = index;
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
              width: _currentIndex == entry.key ? 30.0.w : 8.0.w,
              height: 8.0.h,
              margin: EdgeInsets.symmetric(horizontal: 8.0.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: _currentIndex == entry.key
                    ? Colors.orange
                    : Colors.orange.withOpacity(0.1.sp),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  void watch(){}
  void buyPlan(){}

}

class CustomCard extends StatelessWidget {


  const CustomCard({super.key,});

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
                  image:DecorationImage(image: AssetImage("assets/images/movie1.jpg",),fit: BoxFit.cover),

                ),
           clipBehavior: Clip.antiAlias,
                // child: Image.asset("assets/images/movie1.jpg",fit: BoxFit.cover,)
              ),

              // PG 15+ top-right
              Positioned(
                top: 5,
                right: 10,
                child: Icon(Icons.workspace_premium,size: 28.sp,color: AllColor.amber,)
              ),

              // Left/Right Arrow

            ],
          );
        }
      ),
    );
  }
}
class PPVNoticeSection extends StatelessWidget {
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
BottomNavigationBar buildBottomNavigationBar() {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.white,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'PPV'),
      BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
      BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
    ],
  );
}

