import 'package:flutter/material.dart';
import 'package:plants_app/views/plant_preview/note_card.dart';
import 'package:plants_app/views/plant_preview/reminder_card.dart';

class ChoiceCard extends StatefulWidget {
  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  int widgetChoice = 0;
  List<Widget> items = [];

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

  Widget _buildList() {
    _buildChosenList();
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        },
      ),
    );
  }

  void _buildChosenList() {
    items.clear();
    for (int i = 0; i < 5; i++) {
      items.add(widgetChoice == 0 ? ReminderCard() : NoteCard());
    }
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
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }
}
