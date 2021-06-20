import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';
import 'package:plants_app/utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddLocationDialog extends StatefulWidget {
  @override
  _AddLocationDialogState createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {
  final form = FormGroup({
    'main_location': FormControl<String>(validators: [Validators.required]),
    'location':
        FormControl<String>(value: '', validators: [Validators.required]),
  });

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

  _sendData() async {
    String token = await getToken();
    Location location = new Location();
    location.name = form.control('location').value;
    location.type =
        form.control('main_location').value == 'Outside' ? 'O' : 'I';
    await createLocation(token, location);
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
              _sendData();
              Navigator.pop(context, [
                form.control('main_location').value,
                form.control('location').value
              ]);
            } else {
              form.markAllAsTouched();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Add location'),
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
