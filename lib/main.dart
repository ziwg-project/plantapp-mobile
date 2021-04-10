import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
      ),
    );
  }
}
