import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel extends ChangeNotifier {
  bool _loggedIn = false;
  String _token = "";
  AuthModel() {
    SharedPreferences.getInstance().then((prefs) => {
          log("DUPA"),
          log(prefs.getString('token')),
          if (prefs.containsKey("token")) {this.logIn(prefs.getString('token'))}
        });
  }
  get token => _token;
  get loggedIn => _loggedIn;
  void logIn(token) async {
    _loggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    log(prefs.getString('token'));
    _token = token;
    notifyListeners();
  }

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    _loggedIn = false;
    _token = "";
    notifyListeners();
  }
}
