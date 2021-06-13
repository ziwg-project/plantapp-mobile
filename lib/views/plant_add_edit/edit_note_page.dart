import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import '../../utils.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  EditNotePage({Key key, @required this.note}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState(note);
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  Note note;

  _EditNotePageState(this.note);

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
          initialValue: note.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some words';
            }
            note.text = value;
            return null;
          },
        ),
      ),
    );
  }

  _sendData() async {
    String token = await getToken();
    await updateNote(token, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit note'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _sendData();
                Navigator.pop(context, note);
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
