import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/models/suggestion_model.dart';
import 'package:plants_app/views/locations_list/location_page.dart';
import 'package:plants_app/views/plant_add_edit/photo_card.dart';
import 'package:plants_app/views/plant_add_edit/suggestion_dialog.dart';
import '../../utils.dart';

class AddPlantPage extends StatefulWidget {
  final Function() notifyParent;

  AddPlantPage({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  String locationText;
  Plant plant = new Plant();
  final nameController = TextEditingController();
  final sciNameController = TextEditingController();
  Suggestion suggestion;

  @override
  void dispose() {
    nameController.dispose();
    sciNameController.dispose();
    super.dispose();
  }

  callback(String photoPath) async {
    plant.image = photoPath;
    final result = await showDialog(
        context: context,
        builder: (context) => SuggestionDialog(photoPath: photoPath));
    if (result != null) {
      suggestion = result;
      if (suggestion.plantName.isNotEmpty)
        nameController.text = suggestion.plantName;
      if (suggestion.scientificName != null)
        sciNameController.text = suggestion.scientificName;
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          PhotoCard(notifyParent: callback),
          _buildNameField(),
          _buildScientificNameField(),
          _buildLocationField(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.eco),
            labelText: 'Name',
          ),
          controller: nameController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter plant name';
            }
            plant.name = value;
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildScientificNameField() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.eco_outlined),
            labelText: 'Scientific name',
          ),
          controller: sciNameController,
          validator: (value) {
            if (value.isNotEmpty) {
              plant.sciName = value;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return GestureDetector(
      onTap: () {
        _locationChoicePage(context);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.location_on),
              labelText: locationText == null ? 'Location' : locationText,
              labelStyle: locationText == null
                  ? TextStyle(color: Colors.black54)
                  : TextStyle(color: Colors.black),
              errorStyle: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
            enabled: false,
            validator: (value) {
              if (locationText == null) {
                return 'Please choose a location';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  void _locationChoicePage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationPage(
                  fromList: false,
                )));
    if (result != null) {
      setState(() {
        locationText = result[0];
        plant.locFk = result[1];
      });
    }
  }

  Future<void> sendData() async {
    String token = await getToken();
    final response = await createPlant(token, plant);
    if (response.statusCode == 201 && suggestion != null) {
      final responseString = await response.stream.bytesToString();
      plant = Plant.fromJson(jsonDecode(responseString));
      if (plant.id != null) {
        Note note = new Note();
        note.plantFk = plant.id;
        if (suggestion.commonNames != null) {
          note.text = 'Common names: ' + suggestion.commonNames.join(', ');
          await createNote(token, note);
        }
        if (suggestion.wikiDescription != null) {
          note.text = suggestion.wikiDescription;
          await createNote(token, note);
        }
        if (suggestion.edibleParts != null) {
          note.text = 'Edible parts: ' + suggestion.edibleParts.join(', ');
          await createNote(token, note);
        }
        if (suggestion.propagationMethods != null) {
          note.text = 'Propagation methods: ' +
              suggestion.propagationMethods.join(', ');
          await createNote(token, note);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add plant'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await sendData().then((value) {
                  widget.notifyParent();
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
      body: _buildForm(),
    );
  }
}
