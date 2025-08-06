import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:market_jango/features/home/screens/home_screen.dart';

final GoRouter router = GoRouter(

  initialLocation: "${HomePage.routeName}",
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error } '),
    ),
  ),

  routes: [
    GoRoute(
        path:HomePage.routeName,
      name: "home_page",
    builder: (context,state)=> HomePage(),
    )

  ],
);