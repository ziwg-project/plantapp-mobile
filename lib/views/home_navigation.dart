import 'package:flutter/material.dart';
import 'package:plants_app/views/plants_list_page.dart';

class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  List<Widget> widgetList = [
    PlantsListPage(),
    Center(child: Text('Another page'))
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
          BottomNavigationBarItem(icon: Icon(Icons.more_vert), label: 'Other'),
        ],
        currentIndex: currentIndex,
        onTap: setPage,
      ),
    );
  }
}
