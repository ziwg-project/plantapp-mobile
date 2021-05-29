import 'package:flutter/material.dart';

class EditNotePage extends StatefulWidget {
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();

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
          initialValue:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vehicula felis ac magna dapibus fermentum. Nam mattis lacinia tortor, blandit finibus orci elementum eu. Nam a elit sit amet sem hendrerit blandit in id velit.',
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
        title: Text('Edit note'),
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
