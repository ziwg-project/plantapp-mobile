import 'package:flutter/material.dart';

class AddLocationDialog extends StatefulWidget {
  @override
  _AddLocationDialogState createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {
  final _formKey = GlobalKey<FormState>();
  String _mainLocation;
  String _locationName;

  Widget _buildDropdown() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DropdownButtonFormField(
          hint: Text("Choose main location"),
          value: _mainLocation,
          onChanged: (String value) {
            setState(() {
              _mainLocation = value;
            });
          },
          items: <String>['Inside', 'Outside'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (_mainLocation) {
            if (_mainLocation == null) {
              return 'Please choose a main location';
            }
            return null;
          },
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
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter location name';
            }
            return null;
          },
          onChanged: (String value) {
            _locationName = value;
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
              Navigator.pop(context, [_mainLocation, _locationName]);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add location'),
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
