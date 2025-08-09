import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/features/comedy/screen/shows_comedy_screen.dart';
import 'package:market_jango/features/auth/screens/forgod_screen.dart';
import 'package:market_jango/features/auth/screens/login_screen.dart';
import 'package:market_jango/features/auth/screens/signup_screen.dart';
import 'package:market_jango/features/auth/screens/splash_screen.dart';
import 'package:market_jango/features/home/screens/dashboard_screen.dart';
import 'package:market_jango/features/home/screens/home_screen.dart';
import 'package:market_jango/features/home/screens/my_watchlist_screen.dart';
import 'package:market_jango/features/home/screens/subscription_plan_screen.dart';
import 'package:market_jango/features/home/widgets/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:market_jango/features/live/screen/live_screen.dart';
import 'package:market_jango/features/movies/screen/movies_screen.dart';
import 'package:market_jango/features/music_video/screen/music_video_screen.dart';
import 'package:market_jango/features/nollywood/screen/nollywood_screen.dart';
import 'package:market_jango/features/ppv/screen/ppv_screen.dart';
import 'package:market_jango/features/profile/screen/profile_screen.dart';
import 'package:market_jango/features/setting/screen/setting_screen.dart';
import 'package:market_jango/features/tv_shows/screen/tv_shows_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: "${SplashScreen.routeName}",
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Error: ${state.error} '))),

  routes: [
    GoRoute(
        path:HomeScreen.routeName,
      name: "homePage",
    builder: (context,state)=> HomeScreen(),
    ),
 GoRoute(
        path:ProfileScreen.routeName,
      name: "profile",
    builder: (context,state)=> const ProfileScreen(),
    ),
 GoRoute(
        path:DashboardScreen.routeName,
    name: DashboardScreen.routeName ,
    builder: (context,state)=>const DashboardScreen(),
    ),
 GoRoute(
        path:MyWatchlistScreen.routeName,
      name: MyWatchlistScreen.routeName,
    builder: (context,state)=>const MyWatchlistScreen(),
    ),
GoRoute(
        path:SubscriptionPlanScreen.routeName,
      name: SubscriptionPlanScreen.routeName,
    builder: (context,state)=>const SubscriptionPlanScreen(),
    ),

    GoRoute(
      path: SplashScreen.routeName,
      name: "splash",
      builder: (context, state) => SplashScreen(),
    ),

    GoRoute(
      path: LoginScreen.routeName,
      name: "login_screen",
      builder: (context, state) => LoginScreen(),
    ),

    GoRoute(
      path: SignupScreen.routeName,
      name: "signup_screen",
      builder: (context, state) => SignupScreen(),
    ),

    GoRoute(
      path: ForgotScreen.routeName,
      name: "forgot_screen",
      builder: (context, state) => ForgotScreen(),
    ),

  

    GoRoute(
      path: BottomNavBar.routeName,
      name: "bottom_nav_bar",
      builder: (context, state) => BottomNavBar(),
    ),

    GoRoute(
      path: LiveScreen.routeName,
      name: "live_screen",
      builder: (context, state) => LiveScreen(),
    ),

    GoRoute(
      path: PpvScreen.routeName,
      name: "ppv_screen",
      builder: (context, state) => PpvScreen(),
    ),

    GoRoute(
      path: MoviesScreen.routeName,
      name: MoviesScreen.routeName,
      builder: (context, state) => MoviesScreen(),
    ),
    GoRoute(
      path: TvShowsScreen.routeName,
      name: TvShowsScreen.routeName,
      builder: (context, state) => TvShowsScreen(),
    ),

GoRoute(
      path: MusicVideoScreen.routeName,
      name: MusicVideoScreen.routeName,
      builder: (context, state) => MusicVideoScreen(),
    ),

GoRoute(
      path: NollywoodScreen.routeName,
      name: NollywoodScreen.routeName,
      builder: (context, state) => NollywoodScreen(),
    ),

GoRoute(
      path: ShowsComedyScreen.routeName,
      name: ShowsComedyScreen.routeName,
      builder: (context, state) => ShowsComedyScreen(),
    ),

GoRoute(
      path: SettingScreen.routeName,
      name: SettingScreen.routeName,
      builder: (context, state) => SettingScreen(),
    ),



  ],
);