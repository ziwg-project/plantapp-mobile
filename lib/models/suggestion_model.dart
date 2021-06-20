import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Suggestion {
  String plantName;
  String scientificName;
  List<dynamic> commonNames;
  String wikiDescription;
  List<dynamic> edibleParts;
  List<dynamic> propagationMethods;
  String probability;

  Suggestion(
      {this.plantName,
      this.scientificName,
      this.commonNames,
      this.wikiDescription,
      this.edibleParts,
      this.propagationMethods,
      this.probability});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    String name = json['plant_details']['common_names'] != null
        ? json['plant_details']['common_names'][0]
        : '';
    String description = json['plant_details']['wiki_description'] != null
        ? json['plant_details']['wiki_description']['value']
        : '';
    return Suggestion(
      plantName: name,
      scientificName: json['plant_name'],
      commonNames: json['plant_details']['common_names'],
      wikiDescription: description,
      edibleParts: json['plant_details']['edible_parts'],
      propagationMethods: json['plant_details']['propagation_methods'],
      probability: json['probability'].toStringAsFixed(2),
    );
  }
}

Future<List<Suggestion>> fetchSuggestions(String filePath, String token) async {
  final fileBytes = File(filePath).readAsBytesSync();
  String convertedFile = base64Encode(fileBytes);
  final response = await http.post(
    Uri.parse('https://plantapp.irezwi.pl/api/plant-id/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Token ' + token,
    },
    body: json.encode({
      'images': [convertedFile],
      'plant_details': [
        'common_names',
        'wiki_description',
        'edible_parts',
        'propagation_methods',
      ],
    }),
  );
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var list = data['suggestions'] as List;
    return list.map<Suggestion>((json) => Suggestion.fromJson(json)).toList();
  } else {
    throw Exception('Failure fetching suggestions');
  }
}
