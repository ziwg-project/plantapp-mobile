import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  final String plantId;

  AddNotePage({Key key, @required this.plantId}) : super(key: key);
  @override
  _AddNotePageState createState() => _AddNotePageState(plantId);
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  String locationText;
  String plantId;

  _AddNotePageState(this.plantId);

  Widget _buildField() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 20,
          minLines: 1,
          maxLength: 500,
          decoration: InputDecoration(
            icon: Icon(Icons.eco),
            labelText: 'Note',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some words';
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add note'),
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
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _buildField(),
          ],
        ),
      ),
    );
  }
}
