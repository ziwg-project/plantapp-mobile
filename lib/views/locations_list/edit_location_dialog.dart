import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';

class EditLocationDialog extends StatefulWidget {
  final Location location;

  EditLocationDialog({Key key, @required this.location}) : super(key: key);

  @override
  _EditLocationDialogState createState() => _EditLocationDialogState(location);
}

class _EditLocationDialogState extends State<EditLocationDialog> {
  final _formKey = GlobalKey<FormState>();
  final Location location;

  _EditLocationDialogState(this.location);

  Widget _buildDropdown() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DropdownButtonFormField(
          hint: Text("Choose main location"),
          value: location.type == 'I' ? 'Inside' : 'Outside',
          onChanged: (String value) {
            setState(() {
              location.type = value == 'Inside' ? 'I' : 'O';
            });
          },
          items: <String>['Inside', 'Outside'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
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
            labelText: 'Name',
          ),
          initialValue: location.name,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter location name';
            }
            return null;
          },
          onChanged: (String value) {
            location.name = value;
          },
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context, location);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Edit location'),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildDropdown(),
              _buildNameField(),
              _buildButtons(context),
            ],
          ),
        ),
      ],
    );
  }
}
