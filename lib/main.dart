import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plants_app/models/AuthModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plants_app/views/guest_navigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'views/home_navigation.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

var authModel = new AuthModel();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  
  runApp(
      ChangeNotifierProvider(create: (context) => authModel, child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _register() {
    _firebaseMessaging.getToken().then((token) => authModel.setFirebaseToken(token));
  }

  @override
  void initState() {
    super.initState();
    _register();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      dynamic isUserLogged = authModel.loggedIn;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb && isUserLogged) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  icon: 'launch_background', channelShowBadge: true),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Plants App',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            // Put proper view here later
            home: Scaffold(
                body: Consumer<AuthModel>(builder: (context, auth, child) {
              return Container(
                  child: auth.loggedIn ? HomeNavigation() : GuestNavigation());
            })),
          );
        });
  }
}
