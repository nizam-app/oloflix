import 'package:Oloflix/features/movies_details/screen/movies_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void goToDetailsScreen({required BuildContext context, required int? id}) {
  context.push("${MoviesDetailScreen.routeName}/$id");}