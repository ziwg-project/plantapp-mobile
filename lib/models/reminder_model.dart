import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Reminder {
  int id;
  String text;
  DateTime baseTmstp;
  int intrvlNum;
  String intrvlType;
  int plantFk;

  Reminder({
    this.id,
    this.text,
    this.baseTmstp,
    this.intrvlNum,
    this.intrvlType,
    this.plantFk,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      text: json['text'],
      baseTmstp: DateTime.parse(json['base_tmstp']),
      intrvlNum: json['intrvl_num'],
      intrvlType: json['intrvl_type'],
      plantFk: json['plant_fk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'base_tmstp': baseTmstp.toIso8601String(),
      'intrvl_num': intrvlNum,
      'intrvl_type': intrvlType,
      'plant_fk': plantFk,
    };
  }
}

Future<http.Response> createReminder(String token, Reminder reminder) async {
  return await http.post(
    Uri.parse('https://plantapp.irezwi.pl/api/reminder/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
    body: jsonEncode(reminder),
  );
}

Future<Reminder> fetchReminder(String token, String id) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/reminder/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    return Reminder.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failure fetching reminder');
  }
}

Future<List<Reminder>> fetchAllReminders(String token) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/reminder/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    Iterable list = jsonDecode(utf8.decode(response.bodyBytes));
    return list.map((model) => Reminder.fromJson(model)).toList();
  } else {
    throw Exception('Failure fetching reminders');
  }
}

Future<http.Response> updateReminder(String token, Reminder reminder) async {
  return await http.put(
    Uri.parse('https://plantapp.irezwi.pl/api/reminder/' +
        reminder.id.toString() +
        '/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(reminder),
  );
}

Future<http.Response> deleteReminder(String token, String id) async {
  return await http.delete(
    Uri.parse('https://plantapp.irezwi.pl/api/reminder/' + id + '/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
}
