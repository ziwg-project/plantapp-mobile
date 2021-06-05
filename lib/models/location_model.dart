import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Location {
  int id;
  int ownerFk;
  String name;
  String type; // 'O' or 'I'

  Location({this.id, this.ownerFk, this.name, this.type});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      ownerFk: json['owner_fk'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_fk': ownerFk,
      'name': name,
      'type': type,
    };
  }
}

Future<http.Response> createLocation(String token, Location location) async {
  return await http.post(
    Uri.parse('https://plantapp.irezwi.pl/api/location/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
    body: jsonEncode(location),
  );
}

Future<Location> fetchLocation(String token, String id) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/location/' + id),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    return Location.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failure fetching location');
  }
}

Future<List<Location>> fetchAllLocations(String token) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/location/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    Iterable list = jsonDecode(utf8.decode(response.bodyBytes));
    return list.map((model) => Location.fromJson(model)).toList();
  } else {
    print(response.statusCode);
    throw Exception('Failure fetching locations');
  }
}

Future<http.Response> updateLocation(String token, Location location) async {
  return await http.put(
    Uri.parse('https://plantapp.irezwi.pl/api/location/' +
        location.id.toString() +
        '/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(location),
  );
}

Future<http.Response> deleteLocation(String token, String id) async {
  return await http.delete(
    Uri.parse('https://plantapp.irezwi.pl/api/location/' + id + '/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
}
