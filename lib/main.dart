import 'package:flutter/material.dart';
import 'package:plants_app/models/AuthModel.dart';

import 'package:plants_app/views/guest_navigation.dart';
import 'package:provider/provider.dart';

import 'views/home_navigation.dart';

void main() {
  runApp(

      ChangeNotifierProvider(create: (context) => AuthModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plants App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Put proper view here later
      home: Scaffold(body: Consumer<AuthModel>(builder: (context, auth, child) {
        return Container(
            child: auth.loggedIn ? HomeNavigation() : GuestNavigation());
      })),
    );
  }
}
