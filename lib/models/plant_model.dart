import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Plant {
  int id;
  String name;
  String sciName;
  String image;
  int locFk;

  Plant({this.id, this.name, this.sciName, this.image, this.locFk});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      sciName: json['sci_name'],
      image: json['image'],
      locFk: json['loc_fk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sci_name': sciName,
      'loc_fk': locFk,
    };
  }
}

Future<http.StreamedResponse> createPlant(String token, Plant plant) async {
  var headers = {'Authorization': 'Token ' + token};
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://plantapp.irezwi.pl/api/plant/'));
  request.fields.addAll({
    'name': plant.name,
    if (plant.sciName != null) 'sci_name': plant.sciName,
    'loc_fk': plant.locFk.toString(),
  });
  if (plant.image != null)
    request.files.add(await http.MultipartFile.fromPath('image', plant.image));
  request.headers.addAll(headers);
  return await request.send();
}

Future<Plant> fetchPlant(String token, String id) async {
  final response = await http.get(
    Uri.parse('https://plantapp.irezwi.pl/api/plant/' + id),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    return Plant.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failure fetching plant');
  }
}

Future<List<Plant>> fetchAllPlants(String token, {String query = ""}) async {
  var queryParameters = {'search': query};
  final response = await http.get(
    Uri.https('plantapp.irezwi.pl', '/api/plant/', queryParameters),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
  if (response.statusCode == 200) {
    Iterable list = jsonDecode(utf8.decode(response.bodyBytes));
    return list.map((model) => Plant.fromJson(model)).toList();
  } else {
    throw Exception('Failure fetching locations');
  }
}

Future<http.StreamedResponse> updatePlant(
    String token, Plant plant, bool changingPhoto) async {
  var headers = {'Authorization': 'Token ' + token};
  var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
          'https://plantapp.irezwi.pl/api/plant/' + plant.id.toString() + '/'));
  request.fields.addAll({
    'name': plant.name,
    if (plant.sciName != null) 'sci_name': plant.sciName,
    'loc_fk': plant.locFk.toString(),
  });
  if (plant.image != null && changingPhoto)
    request.files.add(await http.MultipartFile.fromPath('image', plant.image));
  request.headers.addAll(headers);
  return await request.send();
}

Future<http.Response> deletePlant(String token, String id) async {
  return await http.delete(
    Uri.parse('https://plantapp.irezwi.pl/api/plant/' + id + '/'),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
  );
}
