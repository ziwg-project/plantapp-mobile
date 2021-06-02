import 'package:flutter/material.dart';
import 'package:plants_app/views/locations_list/location_page.dart';
import 'package:plants_app/views/plants_list/plants_list_page.dart';

class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  List<Widget> widgetList = [
    PlantsListPage(),
    LocationPage(fromList: true),
  ];
  int currentIndex = 0;

  setPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_outlined),
            label: 'Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Locations',
          ),
        ],
        currentIndex: currentIndex,
        onTap: setPage,
      ),
    );
  }
}
