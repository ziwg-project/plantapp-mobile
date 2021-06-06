import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';
import 'package:plants_app/models/plant_model.dart';
import '../../utils.dart';

class PlantInfoCard extends StatefulWidget {
  final int plantId;

  PlantInfoCard({Key key, @required this.plantId}) : super(key: key);

  @override
  _PlantInfoCardState createState() => _PlantInfoCardState(plantId);
}

class _PlantInfoCardState extends State<PlantInfoCard> {
  final int plantId;
  Future<Widget> _futureWidget;

  _PlantInfoCardState(this.plantId);

  @override
  void initState() {
    super.initState();
    _futureWidget = _buildWidgets();
  }

  @override
  void didUpdateWidget(PlantInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _futureWidget = _buildWidgets();
    });
  }

  Widget _buildPhotoCard(String path) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(path),
            fit: BoxFit.cover,
            alignment: FractionalOffset.topCenter,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)],
        ),
      ),
    );
  }

  Widget _buildInfoRow(Plant plant, Location location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: 5,
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
          height: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              location.type == 'I' ? 'Inside' : 'Outside',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              location.name,
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

  Future<Widget> _buildWidgets() async {
    String token = await getToken();
    Plant plant = await fetchPlant(token, plantId.toString());
    Location location = await fetchLocation(token, plant.locFk.toString());
    return Container(
      height: plant.image == null ? 75 : 300,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (plant.image != null) _buildPhotoCard(plant.image),
            SizedBox(
              height: plant.image == null ? 5 : 10,
            ),
            _buildInfoRow(plant, location),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _futureWidget,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
