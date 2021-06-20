import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditLocationDialog extends StatefulWidget {
  final Location location;

  EditLocationDialog({Key key, @required this.location}) : super(key: key);

  @override
  _EditLocationDialogState createState() => _EditLocationDialogState(location);
}

class _EditLocationDialogState extends State<EditLocationDialog> {
  final form = FormGroup({
    'main_location': FormControl<String>(validators: [Validators.required]),
    'location':
        FormControl<String>(value: '', validators: [Validators.required]),
  });
  final Location location;

  _EditLocationDialogState(this.location);

  @override
  void initState() {
    super.initState();
    form.control('main_location').value =
        location.type == 'I' ? 'Inside' : 'Outside';
    form.control('location').value = location.name;
  }

  Widget _buildDropdown() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ReactiveDropdownField(
          formControlName: 'main_location',
          validationMessages: (control) => {
            ValidationMessage.required: 'Choose main location',
          },
          hint: const Text("Choose main location"),
          items: const <String>['Inside', 'Outside'].map((String value) {
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
        child: ReactiveTextField<String>(
          formControlName: 'location',
          validationMessages: (control) => {
            ValidationMessage.required: 'Please enter location name',
          },
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
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
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (form.valid) {
              location.type =
                  form.control('main_location').value == 'Inside' ? 'I' : 'O';
              location.name = form.control('location').value;
              Navigator.pop(context, location);
            } else {
              form.markAllAsTouched();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Edit location'),
      children: <Widget>[
        ReactiveForm(
          formGroup: form,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildDropdown(),
                _buildNameField(),
                _buildButtons(context),
              ]),
        ),
      ],
    );
  }
}
