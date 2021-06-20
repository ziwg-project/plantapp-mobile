import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
    NotificationSettings settings = await  _firebaseMessaging.requestPermission(alert: true,badge: true, provisional: false,sound: true,);
     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
  }
      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      
      _initialized = true;
    }
  }
}