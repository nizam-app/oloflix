// Flutter imports:
import 'package:Oloflix/features/all_movie/screen/all_movies_screen/all_movie.dart';
import 'package:Oloflix/features/auth/screens/otp_screen.dart';
import 'package:Oloflix/features/auth/screens/reset_password.dart';
import 'package:Oloflix/features/movies/screen/movies_screen.dart';
import 'package:Oloflix/features/movies_details/screen/movies_detail_screen.dart';
import 'package:Oloflix/features/subscription/screen/payment.dart';
import 'package:Oloflix/features/subscription/screen/ppv_subscription.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:Oloflix/features/about/screen/about_screen.dart';
import 'package:Oloflix/features/auth/screens/forgod_screen.dart';
import 'package:Oloflix/features/auth/screens/login_screen.dart';
import 'package:Oloflix/features/auth/screens/signup_screen.dart';
import 'package:Oloflix/features/auth/screens/splash_screen.dart';
import 'package:Oloflix/features/contact/screen/contact_screen.dart';
import 'package:Oloflix/features/delete_account/screen/delete_account_screen.dart';
import 'package:Oloflix/features/deshboard/screen/dashboard_screen.dart';
import 'package:Oloflix/features/home/screens/home_screen.dart';
import 'package:Oloflix/features/live/screen/live_screen.dart';
import 'package:Oloflix/features/notifications/screen/notifications_screen.dart';
import 'package:Oloflix/features/ppv/screen/ppv_screen.dart';
import 'package:Oloflix/features/pricing_refunds/screen/pricing_refunds_screen.dart';
import 'package:Oloflix/features/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:Oloflix/features/profile/screen/profile_screen.dart';
import 'package:Oloflix/features/Notification/screen/notification_screen.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:Oloflix/features/terms_of/screen/terms_of_use_screen.dart';
import 'package:Oloflix/features/tv_shows/screen/tv_shows_screen.dart';
import 'package:Oloflix/features/watchlist/screen/my_watchlist_screen.dart';
import '../features/video_show/video_show_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashScreen.routeName,
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Error: ${state.error} '))),

  routes: [
    // ✅ Splash বাইরে (BottomNav থাকবে না)
    GoRoute(
      path: SplashScreen.routeName,
      name: "splash",
      builder: (context, state) => SplashScreen(),
    ),

    // ✅ Payment বাইরে (BottomNav থাকবে না)
    GoRoute(
      path: PaymentMethod.routeName,
      name: "payment",
      builder: (context, state) {
        final m = (state.extra as Map?) ?? {};
        return PaymentMethod(
          planId: m['planId'] as int?,
          amount: m['amount'] as String?,
          title: m['title'] as String?,
          isInternational: (m['isInternational'] as int?) ?? 0,
          movieId: m['movieId'] as int?,
        );
      },
    ),
    GoRoute(
      path: LoginScreen.routeName,
      name: "login_screen",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: SignupScreen.routeName,
      name: "signup_screen",
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: ForgotScreen.routeName,
      name: "forgot_screen",
      builder: (context, state) => const ForgotScreen(),
    ),
    GoRoute(
      path: OtpScreen.routeName,
      name: "otp",
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: ResetPassword.routeName,
      name: "reset_password",
      builder: (context, state) => const ResetPassword(),
    ),
    GoRoute(
      path: VideoShowScreen.routeName,
      name: VideoShowScreen.routeName,
      builder: (context, state) {
        final videoUrl = state.uri.queryParameters['url'];
        return VideoShowScreen(videoUrl: videoUrl!);
      },
    ),

    // ✅ বাকি সবকিছু ShellRoute-এর ভিতরে (BottomNav সবখানে থাকবে)
    ShellRoute(
      builder: (context, state, child) => BottomNavBar(child: child),
      routes: [
        // Tabs
        GoRoute(
          path: HomeScreen.routeName,
          name: "homePage",
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: PpvScreen.routeName,
          name: "ppv_screen",
          builder: (context, state) => const PpvScreen(),
        ),
        GoRoute(
<<<<<<< HEAD
          path: NotificationsScreen.routeName,
          name: "notifications_screen",
          builder: (context, state) => const NotificationsScreen(),
=======
          path: NotificationScreen.routeName,
          name: "notification_screen",
          builder: (context, state) => const NotificationScreen(),
>>>>>>> dfb80205fcb95e4d7e62a93b9de165653822ef7e
        ),
        GoRoute(
          path: LiveScreen.routeName,
          name: "live_screen",
          builder: (context, state) => const LiveScreen(),
        ),
        GoRoute(
          path: ProfileScreen.routeName,
          name: "profile",
          builder: (context, state) => const ProfileScreen(),
        ),

        // Other screens (সবই BottomNav সহ খোলে)
        GoRoute(
          path: DashboardScreen.routeName,
          name: "dashboard",
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
          path: TvShowsScreen.routeName,
          name: TvShowsScreen.routeName,
          builder: (context, state) => const TvShowsScreen(),
        ),
        GoRoute(
          path: AboutScreen.routeName,
          name: AboutScreen.routeName,
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: TermsOfUseScreen.routeName,
          name: TermsOfUseScreen.routeName,
          builder: (context, state) => const TermsOfUseScreen(),
        ),
        GoRoute(
          path: PrivacyPolicyScreen.routeName,
          name: PrivacyPolicyScreen.routeName,
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: PricingRefundsScreen.routeName,
          name: PricingRefundsScreen.routeName,
          builder: (context, state) => const PricingRefundsScreen(),
        ),
        GoRoute(
          path: ContactScreen.routeName,
          name: ContactScreen.routeName,
          builder: (context, state) => const ContactScreen(),
        ),
        GoRoute(
          path: DeleteAccountScreen.routeName,
          name: DeleteAccountScreen.routeName,
          builder: (context, state) => const DeleteAccountScreen(),
        ),
        GoRoute(
          path: AllMoviesScreen.routeName,
          name: AllMoviesScreen.routeName,
          builder: (context, state) => const AllMoviesScreen(),
        ),
        GoRoute(
          path: PPVSubscriptionPlanScreen.routeName,
          name: "ppv_subscription",
          builder: (context, state) {
            final m = (state.extra as Map?) ?? {};
            final movieId = m['movieId'] as int? ?? 0;
            return PPVSubscriptionPlanScreen(movieId: movieId);
          },
        ),
        GoRoute(
          path: '${MoviesDetailScreen.routeName}/:id',
          name: MoviesDetailScreen.routeName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MoviesDetailScreen(id: id);
          },
        ),
        GoRoute(
          path: '${MoviesScreen.routeName}/:id',
          name: MoviesScreen.routeName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MoviesScreen(movie: id);
          },
        ),

        // Auth screens (এইগুলাও চাইলে bar সহ দেখাতে পারো; না চাইলে বাইরে নিলে হবে)
        
      ],
    ),
  ],
);