import 'package:Oloflix/features/movies_music_video/screen/movies_screen.dart';
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
            onTap: () {
             goToPPvScreen(ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.live_tv),
            title: const Text('Live'),
            onTap: () => context.push(LiveScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.music_video),
            title: const Text('Music video'),
            onTap: () => context.push(MoviesScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.theater_comedy),
            title: const Text('Shows Comedy'),
            onTap: () => context.push(MoviesScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Nollywood & African Movies'),
            onTap: () => context.push(MoviesScreen.routeName),
          ),
        ],
      ),
    );
  }
}