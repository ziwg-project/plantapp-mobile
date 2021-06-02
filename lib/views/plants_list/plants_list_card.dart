import 'package:flutter/material.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/views/plant_preview/plant_preview_page.dart';

class PlantsListCard extends StatefulWidget {
  final Plant plant;
  final Function() notifyParent;

  PlantsListCard({Key key, @required this.plant, @required this.notifyParent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PlantsListCardState(plant);
}

class _PlantsListCardState extends State<PlantsListCard> {
  final Plant plant;
  _PlantsListCardState(this.plant);

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          radius: 30.0,
          backgroundImage:
              (plant.image != null) ? NetworkImage(plant.image) : null,
          backgroundColor: Colors.grey[200],
        ),
        SizedBox(
          width: 25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              plant.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              plant.sciName == null ? '' : plant.sciName,
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlantPage(
                    plantId: plant.id,
                    notifyParent: widget.notifyParent))).then((value) {
          widget.notifyParent();
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildInfoRow(),
        ),
      ),
    );
  }
}
