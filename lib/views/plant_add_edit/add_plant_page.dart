import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/models/suggestion_model.dart';
import 'package:plants_app/views/locations_list/location_page.dart';
import 'package:plants_app/views/plant_add_edit/photo_card.dart';
import 'package:plants_app/views/plant_add_edit/suggestion_dialog.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../utils.dart';

class AddPlantPage extends StatefulWidget {
  final Function() notifyParent;

  AddPlantPage({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  Plant plant = new Plant();
  Suggestion suggestion;
  final form = FormGroup({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'sci_name': FormControl<String>(value: ''),
    'location_text': FormControl<String>(
      value: '',
      validators: [Validators.required],
      disabled: true,
    ),
  });

  callback(String photoPath) async {
    plant.image = photoPath;
    final result = await showDialog(
        context: context,
        builder: (context) => SuggestionDialog(photoPath: photoPath));
    if (result != null) {
      suggestion = result;
      if (suggestion.plantName.isNotEmpty)
        form.control('name').value = suggestion.plantName;
      if (suggestion.scientificName != null)
        form.control('sci_name').value = suggestion.scientificName;
    }
  }

  Widget _buildNameField() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ReactiveTextField<String>(
          formControlName: 'name',
          validationMessages: (control) => {
            ValidationMessage.required: 'Please enter plant name',
          },
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            icon: Icon(Icons.eco),
            labelText: 'Name',
          ),
        ),
      ),
    );
  }

  Widget _buildScientificNameField() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ReactiveTextField<String>(
          formControlName: 'sci_name',
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            icon: Icon(Icons.eco_outlined),
            labelText: 'Scientific name',
          ),
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
          child: ReactiveTextField<String>(
            formControlName: 'location_text',
            validationMessages: (control) => {
              ValidationMessage.required: 'Please choose a location',
            },
            onTap: () {
              _locationChoicePage(context);
            },
            decoration: InputDecoration(
              icon: const Icon(Icons.location_on),
              labelText: form.control('location_text').value == null ||
                      form.control('location_text').value == ''
                  ? 'Location'
                  : form.control('location_text').value,
              labelStyle: form.control('location_text').value == null ||
                      form.control('location_text').value == ''
                  ? TextStyle(color: Colors.black54)
                  : TextStyle(color: Colors.black),
              errorStyle: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
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
      form.control('location_text').value = result[0];
      form.control('location_text').markAsDisabled();
      plant.locFk = result[1];
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> sendData() async {
    String token = await getToken();
    plant.name = form.control('name').value;
    plant.sciName = form.control('sci_name').value;
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
        title: const Text('Add plant'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () async {
              form.control('location_text').markAsEnabled();
              if (form.valid) {
                await sendData().then((value) {
                  widget.notifyParent();
                  Navigator.pop(context);
                });
              } else {
                form.markAllAsTouched();
              }
            },
          ),
        ],
      ),
      body: ReactiveForm(
        formGroup: form,
        child: ListView(
          children: <Widget>[
            PhotoCard(notifyParent: callback),
            _buildNameField(),
            _buildScientificNameField(),
            _buildLocationField(),
          ],
        ),
      ),
    );
  }
}
