import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Note {
  int id;
  String text;
  int plantFk;

  Note({this.id, this.text, this.plantFk});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      text: json['text'],
      plantFk: json['plant_fk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'plant_fk': plantFk,
    };
  }
}

Future<http.Response> createNote(String token, Note note) async {
  return await http.post(
    Uri.parse('https://plantapp.irezwi.pl/api/note/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
    body: jsonEncode(note),
  );
}

Future<Note> fetchNote(String token, String id) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/note/' + id),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    return Note.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failure fetching note');
  }
}

Future<List<Note>> fetchAllNotes(String token) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/note/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    Iterable list = jsonDecode(utf8.decode(response.bodyBytes));
    return list.map((model) => Note.fromJson(model)).toList();
  } else {
    if (response.statusCode == 404) {
      return [];
    }
    throw Exception('Failure fetching notes');
  }
}

Future<http.Response> updateNote(String token, Note note) async {
  return await http.put(
    Uri.parse(
        'https://plantapp.irezwi.pl/api/note/' + note.id.toString() + '/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(note),
  );
}

Future<http.Response> deleteNote(String token, String id) async {
  return await http.delete(
    Uri.parse('https://plantapp.irezwi.pl/api/note/' + id + '/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
}
