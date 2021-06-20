import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ReminderLog {
  int id;
  String logType;
  DateTime logTmstp;
  int reminderFk;

  ReminderLog({
    this.id,
    this.logType,
    this.logTmstp,
    this.reminderFk,
  });

  factory ReminderLog.fromJson(Map<String, dynamic> json) {
    return ReminderLog(
      id: json['id'],
      logType: json['log_type'],
      logTmstp: DateTime.parse(json['log_tmstp']),
      reminderFk: json['reminder_fk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'log_type': logType,
      'log_tmstp': logTmstp.toIso8601String(),
      'reminder_fk': reminderFk,
    };
  }
}

Future<http.Response> createLog(String token, ReminderLog reminderLog) async {
  return await http.post(
    Uri.parse('https://plantapp.irezwi.pl/api/log/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
    body: jsonEncode(reminderLog),
  );
}

Future<ReminderLog> fetchLog(String token, String id) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/log/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    return ReminderLog.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failure fetching log');
  }
}

Future<List<ReminderLog>> fetchAllLogs(String token) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/log/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    Iterable list = jsonDecode(utf8.decode(response.bodyBytes));
    return list.map((model) => ReminderLog.fromJson(model)).toList();
  } else {
    if (response.statusCode == 404) {
      return [];
    }
    throw Exception('Failure fetching logs');
  }
}
