import 'package:flutter/material.dart';
import 'package:plants_app/models/reminder_log_model.dart';
import 'package:intl/intl.dart';

class LogCard extends StatefulWidget {
  final ReminderLog log;
  final String text;

  LogCard({Key key, @required this.log, @required this.text}) : super(key: key);

  @override
  _LogCardState createState() => _LogCardState(log, text);
}

class _LogCardState extends State<LogCard> {
  final ReminderLog log;
  final String text;

  _LogCardState(this.log, this.text);

  List<Widget> _buildLogInfo() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.alarm,
            size: 20.0,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            DateFormat("dd-MM-yyyy hh:mm").format(log.logTmstp),
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: _buildLogInfo(),
        ),
      ),
    );
  }
}
