// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:market_jango/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:market_jango/features/about/screen/about_screen.dart';
import 'package:market_jango/features/auth/screens/forgod_screen.dart';
import 'package:market_jango/features/auth/screens/login_screen.dart';
import 'package:market_jango/features/auth/screens/signup_screen.dart';
import 'package:market_jango/features/auth/screens/splash_screen.dart';
import 'package:market_jango/features/comedy/screen/shows_comedy_screen.dart';
import 'package:market_jango/features/contact/screen/contact_screen.dart';
import 'package:market_jango/features/delete_account/screen/delete_account_screen.dart';
import 'package:market_jango/features/deshboard/screen/dashboard_screen.dart';
import 'package:market_jango/features/home/screens/home_screen.dart';
import 'package:market_jango/features/live/screen/live_screen.dart';
import 'package:market_jango/features/movies/screen/movies_screen.dart';
import 'package:market_jango/features/music_video/screen/music_video_screen.dart';
import 'package:market_jango/features/nollywood/screen/nollywood_screen.dart';
import 'package:market_jango/features/ppv/screen/ppv_screen.dart';
import 'package:market_jango/features/pricing_refunds/screen/pricing_refunds_screen.dart';
import 'package:market_jango/features/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:market_jango/features/profile/screen/profile_screen.dart';
import 'package:market_jango/features/setting/screen/setting_screen.dart';
import 'package:market_jango/features/subscription/screen/subscription_plan_screen.dart';
import 'package:market_jango/features/terms_of/screen/terms_of_use_screen.dart';
import 'package:market_jango/features/tv_shows/screen/tv_shows_screen.dart';
import 'package:market_jango/features/watchlist/screen/my_watchlist_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashScreen.routeName,
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Error: ${state.error} '))),

  routes: [
    GoRoute(
      path: HomeScreen.routeName,
      name: "homePage",
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: ProfileScreen.routeName,
      name: "profile",
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: DashboardScreen.routeName,
      name: DashboardScreen.routeName,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: MyWatchlistScreen.routeName,
      name: MyWatchlistScreen.routeName,
      builder: (context, state) => const MyWatchlistScreen(),
    ),
    GoRoute(
      path: SubscriptionPlanScreen.routeName,
      name: SubscriptionPlanScreen.routeName,
      builder: (context, state) => const SubscriptionPlanScreen(),
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
      path: DashboardScreen.routeName,
      name: "dashboard",
      builder: (context, state) => DashboardScreen(),
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

    // This is Bottom side navigation
    GoRoute(
      path: AboutScreen.routeName,
      name: AboutScreen.routeName,
      builder: (context, state) => AboutScreen(),
    ),
    GoRoute(
      path: TermsOfUseScreen.routeName,
      name: TermsOfUseScreen.routeName,
      builder: (context, state) => TermsOfUseScreen(),
    ),
    GoRoute(
      path: PrivacyPolicyScreen.routeName,
      name: PrivacyPolicyScreen.routeName,
      builder: (context, state) => PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: PricingRefundsScreen.routeName,
      name: PricingRefundsScreen.routeName,
      builder: (context, state) => PricingRefundsScreen(),
    ),
    GoRoute(
      path: ContactScreen.routeName,
      name: ContactScreen.routeName,
      builder: (context, state) => ContactScreen(),
    ),
    GoRoute(
      path: DeleteAccountScreen.routeName,
      name: DeleteAccountScreen.routeName,
      builder: (context, state) => DeleteAccountScreen(),
    ),
  ],
);
