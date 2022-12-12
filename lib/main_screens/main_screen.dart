import 'dart:async';

import 'package:drivers_app/tab_pages/earning_tab.dart';
import 'package:drivers_app/tab_pages/home_tab.dart';
import 'package:drivers_app/tab_pages/profile_tab.dart';
import 'package:drivers_app/tab_pages/rating_tab.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  late int selectedIndex;

  onItemClicked(int index) {
    setState(() {
      tabController!.index = index;
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    onItemClicked(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: const [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), label: "Earnings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.rate_review), label: "Ratings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: ((value) {
          onItemClicked(value);
        }),
      ),
    );
  }
}
