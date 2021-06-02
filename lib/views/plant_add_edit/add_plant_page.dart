import 'package:flutter/material.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/views/locations_list/location_page.dart';
import 'package:plants_app/views/plant_add_edit/photo_card.dart';
import 'package:plants_app/views/plant_add_edit/suggestion_dialog.dart';
import '../../utils.dart';

class AddPlantPage extends StatefulWidget {
  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  String locationText;
  Plant plant = new Plant();
  final nameController = TextEditingController();
  final sciNameController = TextEditingController();

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
      if (result[0].isNotEmpty) nameController.text = result[0];
      if (result[1].isNotEmpty) sciNameController.text = result[1];
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
    await createPlant(token, plant);
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
