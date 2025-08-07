import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/core/constants/color_control/all_color.dart';
import 'package:market_jango/core/constants/color_control/theme_color_controller.dart';
import 'package:market_jango/core/constants/image_control/image_path.dart';
import 'package:market_jango/core/theme/logic/theme_changer.dart';
import 'package:market_jango/features/home/screens/dashboard_screen.dart';
import 'package:market_jango/features/home/screens/my_watchlist_screen.dart';
import 'package:market_jango/features/home/screens/profile_screeen.dart';
import 'package:market_jango/features/home/screens/subscription_plan_screen.dart';

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
              FeaturedMovieSection(),
              PPVNoticeSection(),
              SponsorBanner(),
              RecentlyWatchedSection(),
              PPVMoviesSection(),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: buildBottomNavigationBar(),
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
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('TV Shows'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.music_video_rounded),
            title: const Text('PPV'),
            onTap: () => Navigator.pop(context),
          ),ListTile(
            leading: const Icon(Icons.live_tv),
            title: const Text('Live'),
            onTap: () => Navigator.pop(context),
          ),ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
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

            SizedBox(width: 12.w),


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
                color: Colors.green,
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
              Icon(menuItems[index].icon,color:_themeController.isDarkMode == true?ThemeColorController.white:ThemeColorController.black,),
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



class FeaturedMovieSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg', // Replace with actual image
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('WATCH'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text('BUY PLAN'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class PPVNoticeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        'We are Glad to announce that our PAY-PER-VIEW movies are now available. '
            'These Premium Movies are highly curated and are independent of your current subscription plan...',
        style: TextStyle(color: Colors.white70),
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
            'The Energy Solution\nTEL: 08057046430, 08069715701',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
class RecentlyWatchedSection extends StatelessWidget {
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
Widget buildHorizontalList({required String title, required List<String> images}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(12),
        child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
    ],
  );
}

