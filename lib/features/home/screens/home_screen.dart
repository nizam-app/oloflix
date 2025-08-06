import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_jango/core/constants/color_control/all_color.dart';
import 'package:market_jango/core/constants/color_control/theme_color_controller.dart';
import 'package:market_jango/core/constants/image_control/image_path.dart';

class HomePage extends StatelessWidget {
  static final routeName ="/homePage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopperLogo(),
              FeaturedMovieSection(),
              PPVNoticeSection(),
              SponsorBanner(),
              RecentlyWatchedSection(),
              PPVMoviesSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
class CustomTopperLogo extends StatelessWidget {
   CustomTopperLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset("${ImagePath.logo}",
            width: 80.w,),
            Spacer(),
            InkWell(
              onTap: (){
                goToSearch(context);
              },
              child: CircleAvatar(
                radius: 14.r,
                  backgroundColor: AllColor.red,
                  child: Icon(Icons.search,color: ThemeColorController.white,)),
            ),
            SizedBox(width: 12.w),
            Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
        color: AllColor.amber,
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),),

                child: Icon(Icons.workspace_premium), ),
            // Crown
            SizedBox(width: 12.w),
            Stack(
              children: [
                Icon(Icons.account_circle),
                Positioned(
                  top:0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: AllColor.green500,
                    radius: 4.r,
                  ),
                )
              ],
            ),
            SizedBox(width: 12.w),
          ],
        ),
        SizedBox(height: 20.h,)
      ],

    );
  }
  final List<String> items = [
    'Apple',
    'Banana',
    'Mango',
    'Orange',
    'Pineapple',
    'Watermelon',
    'Grapes',
    'Strawberry'
  ];
 void goToSearch(BuildContext context){
    showSearch(context: context, delegate: CustomSearchDelegate(items));

  }

}
class CustomSearchDelegate extends SearchDelegate {
  final List<String> searchList;

  CustomSearchDelegate(this.searchList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchList
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(results[index]),
        onTap: () {
          close(context, results[index]);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchList
        .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestions[index]),
        onTap: () {
          query = suggestions[index];
          showResults(context);
        },
      ),
    );
  }
}



class FeaturedMovieSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg', // Replace with actual image
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('WATCH'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text('BUY PLAN'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class PPVNoticeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        'We are Glad to announce that our PAY-PER-VIEW movies are now available. '
            'These Premium Movies are highly curated and are independent of your current subscription plan...',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
class SponsorBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'AXTRAB TECHNOLOGY LTD.',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            'The Energy Solution\nTEL: 08057046430, 08069715701',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
class RecentlyWatchedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildHorizontalList(
      title: 'Recently Watched',
      images: [
        'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg',
        'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg',
      ],
    );
  }
}
class PPVMoviesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildHorizontalList(
      title: 'Pay-Per-View Movies (PPV)',
      images: [
        'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg',
        'https://buzznigeria.com/wp-content/uploads/2022/10/ireti.jpg',
      ],
    );
  }
}
Widget buildHorizontalList({required String title, required List<String> images}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(12),
        child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Image.network(images[index]),
            );
          },
        ),
      ),
    ],
  );
}
BottomNavigationBar buildBottomNavigationBar() {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.white,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'PPV'),
      BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
      BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
    ],
  );
}

