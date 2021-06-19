import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:plants_app/models/reminder_model.dart';
import 'package:plants_app/views/plant_add_edit/repeat_picker.dart';

import '../../utils.dart';

class EditReminderPage extends StatefulWidget {
  final Reminder reminder;

  EditReminderPage({Key key, @required this.reminder}) : super(key: key);

  @override
  _EditReminderPageState createState() => _EditReminderPageState(reminder);
}

class _EditReminderPageState extends State<EditReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("dd-MM-yyyy");
  final timeFormat = DateFormat("HH:mm");
  final List<String> intervalList = ['S', 'M', 'H', 'D', 'W', 'm', 'Y'];
  int durationIndex;
  int intervalIndex;
  DateTime date;
  DateTime time;
  Reminder reminder;

  _EditReminderPageState(this.reminder);

  @override
  void initState() {
    super.initState();
    durationIndex = reminder.intrvlNum - 1;
    intervalIndex = intervalList.indexOf(reminder.intrvlType);
  }

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
            icon: const Icon(Icons.eco),
            labelText: 'Name',
          ),
          initialValue: reminder.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter reminder name';
            }
            reminder.text = value;
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
          decoration: const InputDecoration(
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
          initialValue: reminder.baseTmstp,
          validator: (value) {
            if (value == null) {
              return 'Please choose a date';
            }
            date = value;
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
          decoration: const InputDecoration(
            icon: Icon(Icons.alarm),
            labelText: 'Time',
          ),
          format: timeFormat,
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? reminder.baseTmstp),
            );
            return DateTimeField.convert(time);
          },
          initialValue: reminder.baseTmstp,
          validator: (value) {
            if (value == null) {
              return 'Please choose time';
            }
            time = value;
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildRepeatPicker() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          const ListTile(
            title: const Text('Repeat'),
            leading: Icon(Icons.repeat),
          ),
          RepeatPicker(
            durationIndex: durationIndex,
            intervalIndex: intervalIndex,
            notifyParent: callback,
          ),
        ],
      ),
    );
  }

  _sendData() async {
    String token = await getToken();
    reminder.baseTmstp =
        new DateTime(date.year, date.month, date.day, time.hour, time.minute);
    reminder.intrvlNum = durationIndex + 1;
    reminder.intrvlType = intervalList[intervalIndex];
    await updateReminder(token, reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit reminder'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await _sendData();
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
