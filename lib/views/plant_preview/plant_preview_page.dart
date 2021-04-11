import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:plants_app/views/plant_preview/choice_card.dart';
import 'package:plants_app/views/plant_preview/plant_info_card.dart';

class PlantPage extends StatefulWidget {
  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
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
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 25.0,
            ),
            onPressed: () {},
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
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.note_add),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onTap: () {},
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
