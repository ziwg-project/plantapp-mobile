import 'package:flutter/cupertino.dart';

class AuthModel extends ChangeNotifier {
  bool _loggedIn = false;

  get loggedIn => _loggedIn;
  Future<void> logIn() {
    return Future.delayed(Duration(seconds: 0), () {
      _loggedIn = true;
      notifyListeners();
    });
  }

  Future<void> logOut() {
    return Future.delayed(Duration(seconds: 0), () {
      _loggedIn = false;
      notifyListeners();
    });
  }
}
