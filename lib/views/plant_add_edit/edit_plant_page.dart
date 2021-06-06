import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';
import 'package:plants_app/models/note_model.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/models/suggestion_model.dart';
import 'package:plants_app/views/locations_list/location_page.dart';
import 'package:plants_app/views/plant_add_edit/photo_card.dart';
import 'package:plants_app/views/plant_add_edit/suggestion_dialog.dart';
import '../../utils.dart';

class EditPlantPage extends StatefulWidget {
  final int plantId;

  EditPlantPage({Key key, @required this.plantId}) : super(key: key);

  @override
  _EditPlantPageState createState() => _EditPlantPageState(plantId);
}

class _EditPlantPageState extends State<EditPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final sciNameController = TextEditingController();
  String locationText;
  final int plantId;
  bool initialising = true;
  bool changingPhoto = false;
  Plant plant;
  Suggestion suggestion;
  Future<Widget> _futureWidget;
  _EditPlantPageState(this.plantId);

  @override
  void initState() {
    super.initState();
    _futureWidget = _buildForm();
  }

  @override
  void dispose() {
    nameController.dispose();
    sciNameController.dispose();
    super.dispose();
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
        nameController.text = suggestion.plantName;
      if (suggestion.scientificName != null)
        sciNameController.text = suggestion.scientificName;
    }
  }

  Future<Widget> _buildForm() async {
    if (initialising) {
      String token = await getToken();
      plant = await fetchPlant(token, plantId.toString());
      locationText = (await fetchLocation(token, plant.locFk.toString())).name;
      nameController.text = plant.name;
      sciNameController.text = plant.sciName == null ? '' : plant.sciName;
      initialising = false;
    }
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          PhotoCard(
            photoPath: plant.image,
            notifyParent: callback,
          ),
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
            plant.sciName = value;
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
              labelText: locationText,
              labelStyle: TextStyle(color: Colors.black),
            ),
            enabled: false,
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
        _futureWidget = _buildForm();
      });
    }
  }

  Future<void> sendData() async {
    String token = await getToken();
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
              if (_formKey.currentState.validate()) {
                await sendData();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Widget>(
        future: _futureWidget,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
