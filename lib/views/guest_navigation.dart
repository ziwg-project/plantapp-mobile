import 'package:flutter/material.dart';
import 'package:plants_app/views/login_page.dart';

class GuestNavigation extends StatefulWidget {
  @override
  _GuestNavigationState createState() =>  _GuestNavigationState();
  
}

class  _GuestNavigationState extends State<GuestNavigation> {
  List<Widget> widgetList = [
    LoginPage(),
    Center(child: Text('Sign up screen'))
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
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add),label: "Sign up")
        ],
        currentIndex: currentIndex,
        onTap: setPage,
      ),
    );
  }
}
