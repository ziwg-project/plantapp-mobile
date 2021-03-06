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
  Future<Plant> _futurePlant;
  Future<Location> _futureLocation;

  _PlantInfoCardState(this.plantId);

  @override
  void initState() {
    super.initState();
    _futurePlant = _getPlant();
    _futureLocation = _getLocation();
  }

  Future<Plant> _getPlant() async {
    return fetchPlant(await getToken(), plantId.toString());
  }

  Future<Location> _getLocation() async {
    return fetchLocation(
        await getToken(), (await _futurePlant).locFk.toString());
  }

  @override
  void didUpdateWidget(PlantInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _futurePlant = _getPlant();
      _futureLocation = _getLocation();
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
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1.0)],
        ),
      ),
    );
  }

  Widget _buildInfoRow(Plant plant, Location location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(
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
        const SizedBox(
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
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _buildWidgets(Plant plant) {
    return Container(
      height: plant.image == null ? 75 : 300,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
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
            FutureBuilder<Location>(
              future: _futureLocation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildInfoRow(plant, snapshot.data);
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Plant>(
      future: _futurePlant,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildWidgets(snapshot.data);
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
