import 'package:flutter/material.dart';
import 'package:plants_app/views/plant_preview/plant_preview_page.dart';

class PlantsListCard extends StatelessWidget {
  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(
              "https://images.bunches.co.uk/products/large/cheese-plant-1.jpg"),
          backgroundColor: Colors.transparent,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Plant name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Scientific name',
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Water in',
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              '7 days',
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlantPage()));
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
