import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import 'package:plants_app/models/reminder_log_model.dart';
import 'package:plants_app/models/reminder_model.dart';
import 'package:plants_app/views/plant_preview/note_card.dart';
import 'package:plants_app/views/plant_preview/reminder_card.dart';
import '../../utils.dart';
import 'log_card.dart';

class ChoiceCard extends StatefulWidget {
  final int plantId;

  ChoiceCard({Key key, @required this.plantId}) : super(key: key);

  @override
  _ChoiceCardState createState() => _ChoiceCardState(plantId);
}

class _ChoiceCardState extends State<ChoiceCard> {
  final int plantId;
  int widgetChoice = 0;
  Future<List<Reminder>> _futureReminders;
  Future<List<Note>> _futureNotes;
  Future<List<ReminderLog>> _futureLogs;

  _ChoiceCardState(this.plantId);

  @override
  void initState() {
    super.initState();
    _futureReminders = _getReminders();
    _futureNotes = _getNotes();
    _futureLogs = _getLogs();
  }

  Future<List<Reminder>> _getReminders() async {
    return fetchAllReminders(await getToken());
  }

  Future<List<Note>> _getNotes() async {
    return fetchAllNotes(await getToken());
  }

  Future<List<ReminderLog>> _getLogs() async {
    return fetchAllLogs(await getToken());
  }

  @override
  void didUpdateWidget(ChoiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _futureReminders = _getReminders();
      _futureNotes = _getNotes();
      _futureLogs = _getLogs();
    });
  }

  callback() {
    setState(() {
      _futureReminders = _getReminders();
      _futureNotes = _getNotes();
      _futureLogs = _getLogs();
    });
  }

  Widget _buildChoiceRow() {
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: _buildChoiceButton(0),
          ),
          const VerticalDivider(
            color: Colors.grey,
            width: 1,
          ),
          Expanded(
            child: _buildChoiceButton(1),
          ),
          const VerticalDivider(
            color: Colors.grey,
            width: 1,
          ),
          Expanded(
            child: _buildChoiceButton(2),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(int choice) {
    return TextButton(
      onPressed: () {
        setState(() {
          widgetChoice = choice;
          if (choice == 0) {
            _futureReminders = _getReminders();
          }
          if (choice == 1) {
            _futureNotes = _getNotes();
          }
          if (choice == 2) {
            _futureReminders = _getReminders();
            _futureLogs = _getLogs();
          }
        });
      },
      child: choice == 0
          ? const Text('Reminders')
          : choice == 1
              ? const Text('Notes')
              : const Text('History'),
      style: ButtonStyle(
        backgroundColor: widgetChoice == choice
            ? MaterialStateProperty.all<Color>(Colors.green)
            : MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: widgetChoice == choice
            ? MaterialStateProperty.all<Color>(Colors.white)
            : MaterialStateProperty.all<Color>(Colors.green),
      ),
    );
  }

  Widget _buildList() {
    if (widgetChoice == 0) {
      return FutureBuilder<List<Reminder>>(
        future: _futureReminders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> items = [];
            snapshot.data.forEach((reminder) {
              if (reminder.plantFk == plantId)
                items.add(ReminderCard(
                  reminder: reminder,
                  notifyParent: callback,
                  key: UniqueKey(),
                ));
            });
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return items[index];
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    } else if (widgetChoice == 1) {
      return FutureBuilder<List<Note>>(
        future: _futureNotes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> items = [];
            snapshot.data.forEach((note) {
              if (note.plantFk == plantId)
                items.add(NoteCard(
                  note: note,
                  notifyParent: callback,
                  key: UniqueKey(),
                ));
            });
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return items[index];
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    } else {
      return FutureBuilder<List<Reminder>>(
        future: _futureReminders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> items = [];
            List<int> ids = [];
            List<String> reminderTexts = [];
            snapshot.data.forEach((reminder) {
              if (reminder.plantFk == plantId) {
                reminderTexts.add(reminder.text);
                ids.add(reminder.id);
              }
            });
            return FutureBuilder<List<ReminderLog>>(
              future: _futureLogs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (ids.isNotEmpty && reminderTexts.isNotEmpty)
                    snapshot.data
                        .sort((a, b) => -a.logTmstp.compareTo(b.logTmstp));
                  snapshot.data.forEach((log) {
                    if (ids.contains(log.reminderFk))
                      items.add(LogCard(
                        log: log,
                        text: reminderTexts[ids.indexOf(log.reminderFk)] +
                            (log.logType == 'S' ? ' - Skipped' : ' - Done'),
                        key: UniqueKey(),
                      ));
                  });
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return items[index];
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildChoiceRow(),
            _buildList(),
          ],
        ),
      ),
    );
  }
}
