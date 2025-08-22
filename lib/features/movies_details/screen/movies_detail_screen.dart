
import 'package:Oloflix/core/constants/api_control/global_api.dart';
import 'package:Oloflix/core/constants/color_control/all_color.dart';
import 'package:Oloflix/core/widget/base_widget_tupper_botton.dart';
import 'package:Oloflix/core/widget/custom_category_name.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/custom_movie_card.dart';
import 'package:Oloflix/features/home/logic/cetarory_fiend_controller.dart';
import 'package:Oloflix/features/movies_details/logic/get_movie_details.dart';
import 'package:Oloflix/features/subscription/screen/subscription_plan_screen.dart';
import 'package:Oloflix/features/video_show/video_show_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


class MoviesDetailScreen extends ConsumerWidget {
  const MoviesDetailScreen({super.key, required this.id});
  final int id;

  static const String routeName = '/moviesDetailScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = ref.watch(MovieDetailsController.movieByIdProvider(id));
    final youMayAlsoLike = ref.watch(CategoryFindController.categoryFiendProvider("5")) ;
   

    return movie.when(
      data: (movie) {
        if (movie == null) {
          return const Scaffold(
            body: Center(child: Text("Movie not found")),
          );
        }

        return BaseWidgetTupperBotton(
          child1: DetailsImage(imageUrl: "${api}${movie.videoImage}"??'', date: '${movie.releaseDate}', duration: '${movie.duration}', videoUrl: '${movie.videoUrl}',checkPaid: "${movie.videoAccess}",),
          child2: Column(
            children: [
              CustomDescription(
                title: movie.videoTitle ?? '',
                language: "English",
                age: '18+',
                description: movie.videoDescription ?? '',
              ),
              CustomCategoryName(context: context, text: "You May Also Like", onPressed: (){}) ,
          youMayAlsoLike.when(
            data: (movies) => CustomCard(movies: movies,),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text("Error: $e"),
          ),
              SizedBox(height: 20.h,),

            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),
    );
  }

}

class CustomDescription extends StatelessWidget {
  const CustomDescription({super.key, required this.title, required this.language, required this.age, required this.description});
  final String title ;
  final String language ;
  final String age ;
  final  String description ;
  @override
  Widget build(BuildContext context) {
    // Hard-coded data (replace later with API)

    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h,)   ,
            // Title
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),

            // Language + Rating pill
            Row(
              children: [
                Text(
                  language,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20.r), // pill shape
                  ),
                  child: Text(
                    age,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            CustomElevatedbutton(
              title: 'Watch Trailer',
              color: AllColor.orange,
              onPressed: () {},
            ) ,

            // Description
            Text(
              description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

class DetailsImage extends StatelessWidget {
  const DetailsImage({
    super.key, required this.imageUrl, required this.date, required this.duration, required this.videoUrl, required this.checkPaid,
  });
  final String imageUrl ;
  final String videoUrl ;
  final String date;
  final String duration ; // Hard-coded duration, replace later with API
  final String checkPaid;



  @override
  Widget build(BuildContext context) {
 
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          child: Image.network(
            "${imageUrl}",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.h,
          ),
        ),
    
        // Play Button
        Positioned(
          right: 8.w,
          top: 8.h,
          child: InkWell(
            onTap: (){
              if (checkPaid == "Paid") {
                   context.push(SubscriptionPlanScreen.routeName);
              }  else{
              playVideo(context, videoUrl);     }
            },
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.red,
              child: Icon(Icons.play_arrow,
                  color: Colors.white, size: 20.sp),
            ),
          ),
        ),
        Positioned(
          bottom: 48.h,
          left: 3.w,
          child: Row(
            children: [
              // 📅 Date
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.solidCalendarDays,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a')
                        .format(DateTime.parse(date)),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 16.w),

              // ⏰ Duration
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "$duration",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ) ,
        // Buttons over poster bottom
        Positioned(
          bottom: 3.h,
          left: 3.w,
          right: 3.w,
          child: Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.h),
                ),
                onPressed: () {},
                icon: Icon(Icons.add, color: Colors.white, size: 18.sp),
                label: Text(
                  "Add to Watchlist",
                  style:
                  TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              ),
              SizedBox(width: 12.w),
              CustomElevatedbutton(title: 'Watch Trailer', color: AllColor.blue,onPressed: (){},),
            ],
          ),
        ),
      ],
    );
  }
  void playVideo(BuildContext context, String videoUrl) {
    context.push("${VideoShowScreen.routeName}?url=$videoUrl");

  }
}
class CustomElevatedbutton extends StatelessWidget {
  const CustomElevatedbutton({
    super.key, required this.title, required this.color, this.onPressed,
  });
  final String title;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.r),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 12.w, vertical: 8.h),
      ),
      onPressed: onPressed,
      child: Text(
        "$title",
        style:
        TextStyle(color: AllColor.white, fontSize: 13.sp),
      ),
    );
  }
}
class CustomCard extends ConsumerWidget {
  const CustomCard({super.key, required this.movies});
  final dynamic movies;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
          return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies [index];
          return   CustomMoviCard(movie: movie,) ;

        },
      ),
    );
  }
}