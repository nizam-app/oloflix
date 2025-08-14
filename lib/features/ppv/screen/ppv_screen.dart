import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_jango/features/home/widgets/aboute_fooder.dart';

class PpvScreen extends StatelessWidget {
  const PpvScreen({super.key});
  static final routeName = "/ppv_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             playViewText(), 
             SizedBox(height: 20.h,), 
             playMovieList() , 
             SizedBox(height: 60.h,), 
              FooterSection(),

            ],
          ),
        ),
      ),
    );
  
  }
}


Widget playViewText() {
      return Padding(
    padding: EdgeInsets.only(top: 40.h),
    child: Container(
      height: 60.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 119, 93, 184),
        borderRadius: BorderRadius.circular(8),
      ),
     
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "PAY PER VIEW MOVIES",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(), 
        ],
      ),
    ),
  );
}
 



Widget playMovieList() {
  final List<String> images = [
    "assets/images/movie1.png",
    "assets/images/movie2.png",
    "assets/images/movie3.png",
    "assets/images/movie4.png",
    "assets/images/movie5.png",
  ];

  return SingleChildScrollView(
    child: GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigate to new screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetails(image: images[index]),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                ),
                
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                  ),
                ),
                
                Container(
                  
             width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
                borderRadius: BorderRadius.circular(4),
              ),
             
                child:  
              
                  Text("ELENIYAN The retur..", style: TextStyle(color: Colors.white)),
               
              ),
           

                
              ],
            ),
          ),
        );
      },
    ),
  );
}

// New Screen Example
class MovieDetails extends StatelessWidget {
  final String image;
  const MovieDetails({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Detail")),
      body: Center(
        child: Image.asset(image),
      ),
    );
  }
}
