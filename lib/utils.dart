import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  String token = '';
  await SharedPreferences.getInstance().then((prefs) async {
    if (prefs.containsKey('token')) {
      token = prefs.getString('token');
    }
  });
  return token;
}
