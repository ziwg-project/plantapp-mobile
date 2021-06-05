import 'dart:convert';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;

class Suggestion {
  String plantName;
  String scientificName;

  Suggestion({this.plantName, this.scientificName});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    String name = json['plant_details']['common_names'] != null
        ? json['plant_details']['common_names'][0]
        : '';
    return Suggestion(
      plantName: name,
      scientificName: json['plant_name'],
    );
  }
}

Future<List<Suggestion>> fetchSuggestions(String filePath) async {
  final fileBytes = Io.File(filePath).readAsBytesSync();
  String convertedFile = base64Encode(fileBytes);
  final response = await http.post(
    Uri.parse('https://api.plant.id/v2/identify'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'api_key': 'ZXtrTsqbELWetcdeAB9z9strY9vuFVpgNwv4ZJkFsxxIPgHyJn',
      'images': [convertedFile],
      'plant_details': ['common_names'],
    }),
  );
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var list = data['suggestions'] as List;
    return list.map<Suggestion>((json) => Suggestion.fromJson(json)).toList();
  } else {
    print(response.statusCode);
    return [];
  }
}
