import 'package:flutter/material.dart';
import 'package:plants_app/views/locations_list/location_page.dart';
import 'package:plants_app/views/plant_add_edit/photo_card.dart';

class AddPlantPage extends StatefulWidget {
  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  String locationText = 'Location';

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          PhotoCard(),
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
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter plant name';
            }
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
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter plant name';
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
              labelText: locationText,
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
        locationText = result;
      });
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
            onPressed: () {
              // Save data later
              if (_formKey.currentState.validate()) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: _buildForm(),
    );
  }
}
