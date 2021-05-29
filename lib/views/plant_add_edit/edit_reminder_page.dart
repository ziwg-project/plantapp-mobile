import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:plants_app/views/plant_add_edit/repeat_picker.dart';

class EditReminderPage extends StatefulWidget {
  @override
  _EditReminderPageState createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("dd-MM-yyyy");
  final timeFormat = DateFormat("HH:mm");
  List<String> intervalList = ['H', 'D', 'W', 'M'];
  // Get the values when passing data from backend
  bool repeatSwitch = true;
  int durationIndex = 0;
  int intervalIndex = 2;

  callback(int newDuration, int newInterval) {
    setState(() {
      durationIndex = newDuration;
      intervalIndex = newInterval;
    });
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildNameField(),
          _buildDateField(),
          _buildTimeField(),
          _buildRepeatPicker(),
        ],
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
            icon: Icon(Icons.eco),
            labelText: 'Name',
          ),
          initialValue: 'Some name',
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter reminder name';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DateTimeField(
          decoration: InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: 'Start date',
          ),
          format: dateFormat,
          onShowPicker: (context, currentValue) async {
            return showDatePicker(
                context: context,
                initialDate: currentValue ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));
          },
          initialValue: DateTime.now(), // Change to date from backend
          validator: (value) {
            if (value == null) {
              return 'Please choose a date';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DateTimeField(
          decoration: InputDecoration(
            icon: Icon(Icons.alarm),
            labelText: 'Time',
          ),
          format: timeFormat,
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.convert(time);
          },
          initialValue: DateTime.now(), // Change to date from backend
          validator: (value) {
            if (value == null) {
              return 'Please choose time';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildRepeatField() {
    return ListTile(
      title: const Text('Repeat'),
      leading: Icon(Icons.repeat),
      trailing: CupertinoSwitch(
        value: repeatSwitch,
        onChanged: (bool value) {
          setState(() {
            repeatSwitch = value;
          });
        },
      ),
      onTap: () {
        setState(() {
          repeatSwitch = !repeatSwitch;
        });
      },
    );
  }

  Widget _buildRepeatPicker() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          _buildRepeatField(),
          if (repeatSwitch)
            RepeatPicker(
              durationIndex: durationIndex,
              intervalIndex: intervalIndex,
              notifyParent: callback,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit reminder'),
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
      body: _buildForm(),
    );
  }
}
