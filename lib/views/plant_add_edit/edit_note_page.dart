import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../utils.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  EditNotePage({Key key, @required this.note}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState(note);
}

class _EditNotePageState extends State<EditNotePage> {
  Note note;
  final form = FormGroup({
    'text': FormControl<String>(value: '', validators: [Validators.required]),
  });

  _EditNotePageState(this.note);

  @override
  void initState() {
    super.initState();
    form.control('text').value = note.text;
  }

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
          keyboardType: TextInputType.multiline,
          maxLines: 20,
          minLines: 1,
          maxLength: 1000,
          decoration: const InputDecoration(
            icon: Icon(Icons.eco),
            labelText: 'Note',
          ),
        ),
      ),
    );
  }

  _sendData() async {
    String token = await getToken();
    note.text = form.control('text').value;
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
