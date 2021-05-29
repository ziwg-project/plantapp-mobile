import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:plants_app/views/plant_add_edit/add_note_page.dart';
import 'package:plants_app/views/plant_add_edit/add_reminder_page.dart';
import 'package:plants_app/views/plant_add_edit/edit_plant_page.dart';
import 'package:plants_app/views/plant_preview/choice_card.dart';
import 'package:plants_app/views/delete_dialog.dart';
import 'package:plants_app/views/plant_preview/plant_info_card.dart';

class PlantPage extends StatefulWidget {
  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  String plantId; // Needed for add reminder/note

  void _askedToDelete(BuildContext context) async {
    final result = await showDialog(
        context: context, builder: (context) => DeleteDialog());
    if (result != null && result) {
      // Delete from database and return to plants list
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 25.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPlantPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 25.0,
            ),
            onPressed: () {
              _askedToDelete(context);
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.alarm_add),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddReminderPage(
                    plantId: plantId,
                  ),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.note_add),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotePage(
                    plantId: plantId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            PlantInfoCard(),
            ChoiceCard(),
          ],
        ),
      ),
    );
  }
}
