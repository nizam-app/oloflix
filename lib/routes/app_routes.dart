import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(

  initialLocation: "/",
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error } '),
    ),
  ),

  routes: [

  ],
);