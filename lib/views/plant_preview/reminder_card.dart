import 'package:flutter/material.dart';
import 'package:plants_app/views/delete_dialog.dart';
import 'package:plants_app/views/plant_add_edit/edit_reminder_page.dart';

class ReminderCard extends StatelessWidget {
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
              'Reminder name',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Next in 5 days',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
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
      // Delete from database and refresh page
    }
  }

  void _editReminder(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReminderPage(),
      ),
    );
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
