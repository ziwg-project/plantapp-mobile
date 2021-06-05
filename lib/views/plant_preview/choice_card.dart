import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import 'package:plants_app/models/reminder_model.dart';
import 'package:plants_app/views/plant_preview/note_card.dart';
import 'package:plants_app/views/plant_preview/reminder_card.dart';
import '../../utils.dart';

class ChoiceCard extends StatefulWidget {
  final int plantId;

  ChoiceCard({Key key, @required this.plantId}) : super(key: key);

  @override
  _ChoiceCardState createState() => _ChoiceCardState(plantId);
}

class _ChoiceCardState extends State<ChoiceCard> {
  final int plantId;
  int widgetChoice = 0;
  List<Widget> items = [];

  _ChoiceCardState(this.plantId);

  Widget _buildChoiceRow() {
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
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
          VerticalDivider(
            color: Colors.grey,
            width: 1,
          ),
          Expanded(
            child: _buildChoiceButton(1),
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
        });
      },
      child: choice == 0 ? Text('Reminders') : Text('Notes'),
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

  Future<Widget> _buildList() async {
    List<Widget> items = await _buildChosenList();
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        },
      ),
    );
  }

  callback() {
    setState(() {});
  }

  Future<List<Widget>> _buildChosenList() async {
    String token = await getToken();
    List<Widget> items = [];
    if (widgetChoice == 0) {
      List<Reminder> reminders = await fetchAllReminders(token);
      reminders.forEach((reminder) {
        if (reminder.plantFk == plantId)
          items.add(ReminderCard(
            reminder: reminder,
            notifyParent: callback,
          ));
      });
    } else {
      List<Note> notes = await fetchAllNotes(token);
      notes.forEach((note) {
        if (note.plantFk == plantId)
          items.add(NoteCard(
            note: note,
            notifyParent: callback,
          ));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildChoiceRow(),
              FutureBuilder<Widget>(
                future: _buildList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
