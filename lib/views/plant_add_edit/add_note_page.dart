import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import '../../utils.dart';

class AddNotePage extends StatefulWidget {
  final int plantId;

  AddNotePage({Key key, @required this.plantId}) : super(key: key);
  @override
  _AddNotePageState createState() => _AddNotePageState(plantId);
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  int plantId;
  String _noteText;

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
          maxLength: 1000,
          decoration: const InputDecoration(
            icon: Icon(Icons.eco),
            labelText: 'Note',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some words';
            }
            _noteText = value;
            return null;
          },
        ),
      ),
    );
  }

  _sendData() async {
    String token = await getToken();
    Note note = new Note();
    note.text = _noteText;
    note.plantFk = plantId;
    await createNote(token, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add note'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _sendData();
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
