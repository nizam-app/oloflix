import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/features/home/screens/dashboard_screen.dart';
import 'package:market_jango/features/home/screens/home_screen.dart';
import 'package:market_jango/features/home/screens/my_watchlist_screen.dart';
import 'package:market_jango/features/home/screens/profile_screeen.dart';
import 'package:market_jango/features/home/screens/subscription_plan_screen.dart';

final GoRouter router = GoRouter(

  initialLocation: "${HomeScreen.routeName}",
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error } '),
    ),
  ),

  routes: [
    GoRoute(
        path:HomeScreen.routeName,
      name: "home_screen",
    builder: (context,state)=> HomeScreen(),
    ),
 GoRoute(
        path:ProfileScreen.routeName,
      name: "profile_screen",
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


  ],
);