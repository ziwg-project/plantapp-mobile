import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/utils.dart';
import 'package:plants_app/views/drawer_navigation.dart';
import 'package:plants_app/views/plant_add_edit/add_plant_page.dart';
import 'package:plants_app/views/plants_list/plants_list_card.dart';

class PlantsListPage extends StatefulWidget {
  @override
  _PlantsListPageState createState() => _PlantsListPageState();
}

class _PlantsListPageState extends State<PlantsListPage> {
  Future<List<List<Widget>>> _buildSpecificLocations(
      List<Location> locations, List<Plant> plants) async {
    List<Widget> inside = [];
    List<Widget> outside = [];
    for (int i = 0; i < locations.length; i++) {
      List<Plant> chosenPlants =
          plants.where((plant) => plant.locFk == locations[i].id).toList();
      if (chosenPlants.isNotEmpty) {
        locations[i].type == 'I'
            ? inside.add(
                Card(
                  child: ExpansionTile(
                    title: Text(
                      locations[i].name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: true,
                    children: _buildExpandedItems(chosenPlants),
                  ),
                ),
              )
            : outside.add(
                Card(
                  child: ExpansionTile(
                    title: Text(
                      locations[i].name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: true,
                    children: _buildExpandedItems(chosenPlants),
                  ),
                ),
              );
      }
    }
    return [inside, outside];
  }

  callback() {
    setState(() {});
  }

  List<Widget> _buildExpandedItems(List<Plant> plants) {
    List<Widget> list = [];
    for (int i = 0; i < plants.length; i++) {
      list.add(
        PlantsListCard(plant: plants[i], notifyParent: callback),
      );
    }
    return list;
  }

  Future<List<Widget>> _buildWidgets() async {
    String token = await getToken();
    List<Widget> items = [];
    List<Location> locations = await fetchAllLocations(token);
    List<Plant> plants = await fetchAllPlants(token);
    List<List<Widget>> specificLocations =
        await _buildSpecificLocations(locations, plants);
    for (int i = 0; i < 2; i++) {
      items.add(
        Card(
          child: ExpansionTile(
            title: Text(i == 0 ? 'Inside' : 'Outside',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            initiallyExpanded: true,
            children: specificLocations[i],
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plants'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPlantPage(),
                ),
              ).then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      drawer: DrawerNavigation(),
      body: Container(
        child: FutureBuilder<List<Widget>>(
          future: _buildWidgets(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return snapshot.data[index];
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
