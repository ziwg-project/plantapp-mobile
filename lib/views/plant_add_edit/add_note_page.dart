import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import '../../utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddNotePage extends StatefulWidget {
  final int plantId;

  AddNotePage({Key key, @required this.plantId}) : super(key: key);
  @override
  _AddNotePageState createState() => _AddNotePageState(plantId);
}

class _AddNotePageState extends State<AddNotePage> {
  int plantId;
  final form = FormGroup({
    'text': FormControl<String>(value: '', validators: [Validators.required]),
  });

  _AddNotePageState(this.plantId);

  Widget _buildField() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ReactiveTextField<String>(
          formControlName: 'text',
          validationMessages: (control) => {
            ValidationMessage.required: 'Please enter some words',
          },
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            icon: Icon(Icons.eco),
            labelText: 'Note',
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 20,
          minLines: 1,
          maxLength: 1000,
        ),
      ),
    );
  }

  _sendData() async {
    String token = await getToken();
    Note note = new Note();
    note.text = form.control('text').value;
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
              if (form.valid) {
                _sendData();
                Navigator.pop(context);
              } else {
                form.markAllAsTouched();
              }
            },
          ),
        ],
      ),
      body: ReactiveForm(
        formGroup: form,
        child: ListView(children: <Widget>[
          _buildField(),
        ]),
      ),
    );
  }
}
