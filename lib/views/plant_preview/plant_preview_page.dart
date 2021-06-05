import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/views/plant_add_edit/add_note_page.dart';
import 'package:plants_app/views/plant_add_edit/add_reminder_page.dart';
import 'package:plants_app/views/plant_add_edit/edit_plant_page.dart';
import 'package:plants_app/views/plant_preview/choice_card.dart';
import 'package:plants_app/views/delete_dialog.dart';
import 'package:plants_app/views/plant_preview/plant_info_card.dart';
import '../../utils.dart';

class PlantPage extends StatefulWidget {
  final int plantId;
  final Function() notifyParent;

  PlantPage({Key key, @required this.plantId, @required this.notifyParent})
      : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState(plantId);
}

class _PlantPageState extends State<PlantPage> {
  final int plantId;
  _PlantPageState(this.plantId);

  void _askedToDelete(BuildContext context) async {
    final result = await showDialog(
        context: context, builder: (context) => DeleteDialog());
    if (result != null && result) {
      String token = await getToken();
      await deletePlant(token, plantId.toString());
      widget.notifyParent();
      Navigator.pop(context);
    }
  }

  Future<Widget> _buildWidgets() async {
    return Column(
      children: <Widget>[
        PlantInfoCard(plantId: plantId),
        ChoiceCard(plantId: plantId),
      ],
    );
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
                  builder: (context) => EditPlantPage(
                    plantId: plantId,
                  ),
                ),
              ).then((value) {
                setState(() {});
              });
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
              ).then((value) {
                setState(() {});
              });
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
              ).then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<Widget>(
          future: _buildWidgets(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
