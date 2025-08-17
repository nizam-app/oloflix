// Flutter imports:
import 'package:flutter/material.dart';
import 'package:Oloflix/core/widget/base_widget_tupper_botton.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/move_fildering.dart';

class TvShowsScreen extends StatelessWidget {
  const TvShowsScreen({super.key});
  static final routeName = "/tvShowsScreen";

  @override
  Widget build(BuildContext context) {
    return BaseWidgetTupperBotton(child:FilterDropdownSection(),);
  }
}