import 'package:flutter/material.dart';
import 'package:flexify/screens/home_screen.dart';
import 'package:flexify/screens/recommend_screen.dart';
import 'package:flexify/screens/search_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.black,
            height: 70,
            child: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home,
                  ),
                  text: "Home",
                ),
                Tab(
                  icon: Icon(
                    Icons.search,
                  ),
                  text: "Search",
                ),
                Tab(
                  icon: Icon(
                    Icons.recommend,
                  ),
                  text: "Recommend",
                ),
              ],
              indicatorColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xff999999),
            ),
          ),
          body: TabBarView(children: [
            HomeScreen(),
            SearchScreen(),
            RecommendScreen(),
          ]),
        ));
  }
}
