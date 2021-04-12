import 'package:flutter/material.dart';

class EditLocationDialog extends StatefulWidget {
  final String mainLocation;
  final String locationName;

  EditLocationDialog(
      {Key key, @required this.mainLocation, @required this.locationName})
      : super(key: key);

  @override
  _EditLocationDialogState createState() =>
      _EditLocationDialogState(mainLocation, locationName);
}

class _EditLocationDialogState extends State<EditLocationDialog> {
  final _formKey = GlobalKey<FormState>();
  String _mainLocation;
  String _locationName;

  _EditLocationDialogState(this._mainLocation, this._locationName);

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
          initialValue: _locationName,
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
