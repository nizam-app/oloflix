import 'package:Oloflix/features/all_movie/screen/all_movies_screen/all_movie.dart';
import 'package:Oloflix/features/movies/screen/movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:Oloflix/core/constants/color_control/theme_color_controller.dart';
import 'package:Oloflix/core/constants/image_control/image_path.dart';
import 'package:Oloflix/features/live/screen/live_screen.dart';


import 'package:Oloflix/features/tv_shows/screen/tv_shows_screen.dart';

import 'bottom_nav_bar/controller/bottom_controller.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onTap: () => context.push(AllMoviesScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('TV Shows'),
            onTap: () => context.push(TvShowsScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.music_video_rounded),
            title: const Text('PPV'),
            onTap: () {
             goToPPvScreen(ref,context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.live_tv),
            title: const Text('Live'),
            onTap: () {   final premium = hasPremium(ref);
            if (!premium) {
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Please purchase the YEARLY subscription to view page!!"),
                    ),
                  );
              }
              return; // index change হবে না
            }else {
              context.push(LiveScreen.routeName) ;
            }},
          ),
          ListTile(
            leading: const Icon(Icons.music_video),
            title: const Text('Music video'),
            onTap: () { context.push("${MoviesScreen.routeName}/12");}
          ),
          ListTile(
            leading: const Icon(Icons.theater_comedy),
            title: const Text('Shows Comedy'),
            onTap: ()  { context.push("${MoviesScreen.routeName}/14");},
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Nollywood & African Movies'),
            onTap: () { context.push("${MoviesScreen.routeName}/2");},
          ),
        ],
      ),
    );
  }
}