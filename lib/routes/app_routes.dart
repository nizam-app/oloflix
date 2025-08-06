import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/features/auth/screens/forgod_screen.dart';
import 'package:market_jango/features/auth/screens/login_screen.dart';
import 'package:market_jango/features/auth/screens/signup_screen.dart';
import 'package:market_jango/features/auth/screens/splash_screen.dart';
import 'package:market_jango/features/home/screens/home_screen.dart';

final GoRouter router = GoRouter(

  initialLocation: "${SplashScreen.routeName}",
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error } '),
    ),
  ),

  routes: [
    GoRoute(
        path:HomePage.routeName,
      name: "homePage",
    builder: (context,state)=> HomePage(),
    ),

    GoRoute(
        path:SplashScreen.routeName,
      name: "splash",
    builder: (context,state)=> SplashScreen(),
    ),
 GoRoute(
      path:LoginScreen.routeName,
      name: "login_screen",
    builder: (context,state)=> LoginScreen(),
    ),

    GoRoute(
      path:SignupScreen.routeName,
      name: "signup_screen",
    builder: (context,state)=> SignupScreen(),
    ),

GoRoute(
      path:ForgotScreen.routeName,
      name: "forgot_screen",
    builder: (context,state)=> ForgotScreen(),
    ), 

  ],
);