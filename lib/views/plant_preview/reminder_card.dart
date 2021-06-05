import 'package:flutter/material.dart';
import 'package:plants_app/models/reminder_model.dart';
import 'package:plants_app/views/delete_dialog.dart';
import 'package:plants_app/views/plant_add_edit/edit_reminder_page.dart';
import '../../utils.dart';

class ReminderCard extends StatefulWidget {
  final Reminder reminder;
  final Function() notifyParent;

  ReminderCard({Key key, @required this.reminder, @required this.notifyParent})
      : super(key: key);

  @override
  _ReminderCardState createState() => _ReminderCardState(reminder);
}

class _ReminderCardState extends State<ReminderCard> {
  final Reminder reminder;

  _ReminderCardState(this.reminder);

  Widget _buildReminderInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          Icons.alarm,
          size: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              reminder.text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _getReminderText(),
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  String _getReminderText() {
    String text = 'Every ' + reminder.intrvlNum.toString();
    switch (reminder.intrvlType) {
      case 'S':
        text += ' seconds';
        break;
      case 'M':
        text += ' minutes';
        break;
      case 'H':
        text += ' hours';
        break;
      case 'D':
        text += ' days';
        break;
      case 'W':
        text += ' weeks';
        break;
      case 'm':
        text += ' months';
        break;
      case 'Y':
        text += ' years';
        break;
    }
    return text;
  }

  void _showPopupMenu(Offset offset, BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Row(
            children: <Widget>[
              Icon(Icons.edit),
              const SizedBox(
                width: 5,
              ),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              const SizedBox(
                width: 5,
              ),
              Text('Delete'),
            ],
          ),
        ),
      ],
    ).then(
      (value) {
        if (value != null) {
          value == 0 ? _editReminder(context) : _askedToDelete(context);
        }
      },
    );
  }

  void _askedToDelete(BuildContext context) async {
    final result = await showDialog(
        context: context, builder: (context) => DeleteDialog());
    if (result != null && result) {
      String token = await getToken();
      await deleteReminder(token, reminder.id.toString());
      widget.notifyParent();
    }
  }

  void _editReminder(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReminderPage(reminder: reminder),
      ),
    );
    widget.notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _showPopupMenu(details.globalPosition, context);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: _buildReminderInfo(),
        ),
      ),
    );
  }
}
