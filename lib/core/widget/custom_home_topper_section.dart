// Flutter imports:
import 'package:Oloflix/%20business_logic/models/movie_details_model.dart';
import 'package:Oloflix/core/constants/api_control/global_api.dart';
import 'package:Oloflix/core/utils/logOut_botton.dart';
import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:Oloflix/features/movies_details/logic/get_movie_details.dart';
import 'package:Oloflix/features/movies_details/screen/movies_detail_screen.dart';
import 'package:Oloflix/features/profile/logic/login_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/constants/color_control/theme_color_controller.dart';
import 'package:Oloflix/core/constants/image_control/image_path.dart';
import 'package:Oloflix/core/theme/logic/theme_changer.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:Oloflix/features/deshboard/screen/dashboard_screen.dart';
import 'package:Oloflix/features/home/screens/home_screen.dart';
import 'package:Oloflix/features/profile/screen/profile_screen.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:Oloflix/features/watchlist/screen/my_watchlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomHomeTopperSection extends ConsumerWidget {
  CustomHomeTopperSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: (){
                context.go(HomeScreen.routeName);
              },
                child: Image.asset(ImagePath.logo, width: 80.w)),
            Spacer(),
    ref.watch( MovieDetailsController.movieDetailsProvider).when(
    data: (movies) {
    return  InkWell(
      onTap: () {
        goToSearch(context,movies);
      },
      child: CircleAvatar(
        radius: 14.r,
        backgroundColor: AllColor.red,
        child: Icon(Icons.search, color: ThemeColorController.white),
      ),
    );
    },
    loading: () => const CircularProgressIndicator(),
    error: (e, _) => Text("Error: $e"),
    ),
            SizedBox(width: 20.w),
            InkWell(
              onTap: () {
                goToSubscriptionScreen(context);
              },
              child: Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  color: AllColor.amber,
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                ),

                child: Icon(Icons.workspace_premium),
              ),
            ),
            // Crown
            SizedBox(width: 5.w),
            _UserMenu(menuItems: menuItems),

            IconButton(
              icon: Icon(Icons.menu_rounded, color: Colors.white, size: 24.sp),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
            SizedBox(width: 5.w),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  final List<_MenuItem> menuItems = [
    _MenuItem('Dashboard', Icons.storage),
    _MenuItem('Profile', Icons.person),
    _MenuItem('My Watchlist', Icons.list_alt),
    _MenuItem('Logout', Icons.logout),
  ];

  void goToSearch(BuildContext context, List<MovieDetailsModel> movies) {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(movies),
    ).then((selectedMovie) {
      if (selectedMovie != null) {
        // এখানে তুমি ডিটেইলস স্ক্রিনে যেতে পারবা
        print("Selected Movie: ${selectedMovie.videoTitle}");
      }
    });
  }

void goToSubscriptionScreen(BuildContext context)   async  {
  final bool loggedIn = await AuthHelper.isLoggedIn();

    if (!loggedIn) {
      context.push(LoginScreen.routeName);
      return;
    }
    context.push(SubscriptionPlanScreen.routeName);
  }
}
class CustomSearchDelegate extends SearchDelegate<MovieDetailsModel?> {
  final List<MovieDetailsModel> movies;

  CustomSearchDelegate(this.movies);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
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
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = movies.where((movie) =>
        movie.videoTitle.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return _buildMovieList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = movies.where((movie) =>
        movie.videoTitle.toLowerCase().startsWith(query.toLowerCase())
    ).toList();

    return _buildMovieList(suggestions);
  }

  Widget _buildMovieList(List<MovieDetailsModel> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final movie = list[index];
        return ListTile(
          leading: Image.network("${api}${movie.videoImageThumb}", width: 50, fit: BoxFit.cover),
          title: Text(movie.videoTitle),
          subtitle: Text(movie.duration),
          onTap: () {
            context.push("${MoviesDetailScreen.routeName}/${movie.id}"); // movie select করলে return হবে
          },
        );
      },
    );
  }
}


class _UserMenu extends StatelessWidget {
  final List<_MenuItem> menuItems;

  const _UserMenu({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    final ThemeChanger themeController = Get.put(ThemeChanger());
    return PopupMenuButton<int>(
      icon: Stack(
        children: [
          Icon(Icons.person, size: 24.sp),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: ThemeColorController.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeColorController.white,
                  width: 1.w,
                ),
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (context) => List.generate(
        menuItems.length,
        (index) => PopupMenuItem<int>(
          value: index,
          child: Row(
            children: [
              Icon(
                menuItems[index].icon,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
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

// আগের onSelected একই থাকবে:
// onSelected: (index) { goToNextPage(index, context); },

  Future<void> goToNextPage(int index, BuildContext context) async {
    final bool loggedIn = await AuthHelper.isLoggedIn();

    if (index == 0) {
      // Dashboard
      if (!loggedIn) {
        context.push(LoginScreen.routeName);
        return;
      }
      context.push(DashboardScreen.routeName);

    } else if (index == 1) {
      // Profile
      if (!loggedIn) {
        context.push(LoginScreen.routeName);
        return;
      }
      context.push(ProfileScreen.routeName);

    } else if (index == 2) {
      // My Watchlist
      if (!loggedIn) {
        context.push(LoginScreen.routeName);
        return;
      }
      context.push(MyWatchlistScreen.routeName);

    } else if (index == 3) {
      // Logout (logged-in না থাকলে Login এ নেবে)
      if (!loggedIn) {
        context.push(LoginScreen.routeName);
        return;
      }

      showLogOutDialog(context);
    }
  }






}

class _MenuItem {
  final String title;
  final IconData icon;

  _MenuItem(this.title, this.icon);
}