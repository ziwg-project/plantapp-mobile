import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel extends ChangeNotifier {
  bool _loggedIn = false;
  String _token = "";
  String _firebaseToken = "";
  AuthModel() {
    SharedPreferences.getInstance().then((prefs) => {
          if (prefs.containsKey("token")) {this.logIn(prefs.getString('token'))}
        });
  }
  get token => _token;
  get loggedIn => _loggedIn;
  get firebaseToken => _firebaseToken;
  void setFirebaseToken(token) {
    _firebaseToken = token;
    notifyListeners();
  }

  void logIn(token) async {
    _loggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
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
