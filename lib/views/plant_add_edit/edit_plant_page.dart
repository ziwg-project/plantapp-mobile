import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';
import 'package:plants_app/models/note_model.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/models/suggestion_model.dart';
import 'package:plants_app/views/locations_list/location_page.dart';
import 'package:plants_app/views/plant_add_edit/photo_card.dart';
import 'package:plants_app/views/plant_add_edit/suggestion_dialog.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../utils.dart';

class EditPlantPage extends StatefulWidget {
  final int plantId;

  EditPlantPage({Key key, @required this.plantId}) : super(key: key);

  @override
  _EditPlantPageState createState() => _EditPlantPageState(plantId);
}

class _EditPlantPageState extends State<EditPlantPage> {
  final int plantId;
  bool changingPhoto = false;
  Plant plant;
  Suggestion suggestion;
  Future<Plant> _futurePlant;
  Future<String> _futureText;
  _EditPlantPageState(this.plantId);
  final form = FormGroup({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'sci_name': FormControl<String>(value: ''),
    'location_text': FormControl<String>(value: '', disabled: true),
  });

  @override
  void initState() {
    super.initState();
    _futurePlant = _getPlant();
    _futureText = _getLocationText();
  }

  Future<Plant> _getPlant() async {
    return fetchPlant(await getToken(), plantId.toString());
  }

  Future<String> _getLocationText() async {
    return (await fetchLocation(
            await getToken(), (await _futurePlant).locFk.toString()))
        .name;
  }

  callback(String photoPath) async {
    plant.image = photoPath;
    changingPhoto = true;
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

  Widget _buildForm() {
    return ReactiveForm(
      formGroup: form,
      child: ListView(
        children: <Widget>[
          PhotoCard(
            photoPath: plant.image,
            notifyParent: callback,
          ),
          _buildNameField(),
          _buildScientificNameField(),
          FutureBuilder<String>(
            future: _futureText,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (form.control('location_text').value == null ||
                    form.control('location_text').value == '')
                  form.control('location_text').value = snapshot.data;
                return _buildLocationField();
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
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
            decoration: InputDecoration(
              icon: const Icon(Icons.location_on),
              labelText: form.control('location_text').value,
              labelStyle: const TextStyle(color: Colors.black),
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
      plant.locFk = result[1];
    }
  }

  Future<void> sendData() async {
    String token = await getToken();
    plant.name = form.control('name').value;
    plant.sciName = form.control('sci_name').value;
    await updatePlant(token, plant, changingPhoto);
    if (suggestion != null) {
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
        note.text =
            'Propagation methods: ' + suggestion.propagationMethods.join(', ');
        await createNote(token, note);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit plant'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () async {
              if (form.valid) {
                await sendData();
                Navigator.pop(context);
              } else {
                form.markAllAsTouched();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Plant>(
        future: _futurePlant,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            plant = snapshot.data;
            form.control('name').value = plant.name;
            form.control('sci_name').value =
                plant.sciName == null ? '' : plant.sciName;
            return _buildForm();
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
