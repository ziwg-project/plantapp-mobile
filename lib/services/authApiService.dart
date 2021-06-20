import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/AuthModel.dart';

class TokenKey {
  final String token;
  TokenKey(this.token);
  TokenKey.fromJson(Map<String, dynamic> json) : token = json['key'];
  Map<String, dynamic> toJson() => {
        'key': token,
      };
}

// {
//     "name": "",
//     "registration_id": "asdasd",
//     "device_id": "",
//     "active": true,
//     "type": "android"
// }
class FirebaseDevice {
  final String name = "";
  final String registrationid;
  final String deviceid = "";
  final bool active = true;
  final String type = 'android';
  FirebaseDevice(this.registrationid);
  Map<String, dynamic> toJson() => {
        'name': name,
        'registration_id': registrationid,
        'device_id': deviceid,
        'active': active,
        'type': type,
      };
}

class AuthApiService {
  static Future<bool> signUp(credentials, context) async {
    final response = await http.post(
        Uri.parse("https://plantapp.irezwi.pl/api/auth/registration"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(credentials));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: new Text(
              "Account has been successfully created, you can now log in")));
      return true;
    } else {
      log(jsonEncode(response.statusCode));
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: new Text(
              "Credentails are already in use or your password is too weak")));
      return false;
    }
  }

  static void registerDevice(firebaseToken, apiToken) async {
    log(apiToken);
    var payload = FirebaseDevice(firebaseToken);
    final response =
        await http.post(Uri.parse("https://plantapp.irezwi.pl/api/devices/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Token ' + apiToken
            },
            body: jsonEncode(payload));
    log(response.body);
  }

  static void signIn(
      credentials, context, AuthModel authService, firebaseToken) async {
    final response =
        await http.post(Uri.parse("https://plantapp.irezwi.pl/api/auth/login/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(credentials));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      var responseBody = TokenKey.fromJson(responseMap);
      authService.logIn(responseBody.token);
      registerDevice(firebaseToken, responseBody.token);
      ScaffoldMessenger.of(context).showSnackBar(
          new SnackBar(content: new Text("You're now logged in")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          new SnackBar(content: new Text("Username/ password incorrect")));
    }
  }
}
