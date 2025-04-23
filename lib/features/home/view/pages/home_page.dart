import 'package:flutter/material.dart';
import 'package:the_movie_db/features/now_playing/view/pages/now_playing_page.dart';
import 'package:the_movie_db/features/popular/view/pages/popular_page.dart';
import 'package:the_movie_db/features/top_rated/view/pages/top_rated_page.dart';
import 'package:the_movie_db/features/upcoming/view/pages/upcoming_page.dart';

List<Widget> homeLayouts = [
  NowPlayingPage(),
  PopularPage(),
  TopRatedPage(),
  UpcomingPage(),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeLayouts.elementAt(currentPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: "Now Playing",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: "Popular"),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: "Top Rated",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upcoming),
            label: "Upcoming",
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.white,
        currentIndex: currentPageIndex,
        onTap: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
      ),
    );
  }
}
