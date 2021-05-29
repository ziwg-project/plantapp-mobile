import 'package:flutter/material.dart';
import 'package:plants_app/models/AuthModel.dart';
import 'package:provider/provider.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: (context, auth, child) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                  child: Text(
                'Plant app',
              )),
            ),
            ListTile(
              title: Text('Log out'),
              trailing: Icon(Icons.logout),
              onTap: () {
                auth.logOut();
                ScaffoldMessenger.of(context).showSnackBar(
                    new SnackBar(content: new Text("You've been logged out")));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
