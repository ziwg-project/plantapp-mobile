import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';
import 'package:plants_app/models/plant_model.dart';
import 'package:plants_app/utils.dart';
import 'package:plants_app/views/drawer_navigation.dart';
import 'package:plants_app/views/plant_add_edit/add_plant_page.dart';
import 'package:plants_app/views/plants_list/plants_list_card.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'dart:async';

class PlantsListPage extends StatefulWidget {
  @override
  _PlantsListPageState createState() => _PlantsListPageState();
}

class _PlantsListPageState extends State<PlantsListPage> {
  Future<List<Location>> _futureLocations;
  Future<List<Plant>> _futurePlants;

  @override
  void initState() {
    super.initState();
    _futureLocations = _getLocations();
    _futurePlants = _getPlants('');
  }

  Future<List<Location>> _getLocations() async {
    return fetchAllLocations(await getToken());
  }

  Future<List<Plant>> _getPlants(String query) async {
    return fetchAllPlants(await getToken(), query: query);
  }

  final searchForm = FormGroup({
    'name': FormControl<String>(value: ''),
  });

  List<List<Widget>> _buildSpecificLocations(
      List<Location> locations, List<Plant> plants) {
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
    setState(() {
      _futureLocations = _getLocations();
      _futurePlants = _getPlants(this.searchForm.control('name').value);
    });
  }

  onSearchSubmit() async {
    String token = await getToken();
    this.setState(() {
      _futurePlants =
          fetchAllPlants(token, query: this.searchForm.control('name').value);
    });
  }

  List<Widget> _buildExpandedItems(List<Plant> selectedPlants) {
    List<Widget> list = [];
    for (int i = 0; i < selectedPlants.length; i++) {
      list.add(
        PlantsListCard(
            plant: selectedPlants[i], notifyParent: callback, key: UniqueKey()),
      );
    }
    return list;
  }

  Widget _buildWidgets(List<Location> locations) {
    return FutureBuilder<List<Plant>>(
      future: _futurePlants,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> items = [];
          List<List<Widget>> specificLocations =
              _buildSpecificLocations(locations, snapshot.data);
          items.add(ReactiveForm(
              formGroup: this.searchForm,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ReactiveForm(
                          formGroup: this.searchForm,
                          child: ReactiveTextField<String>(
                              formControlName: 'name',
                              onSubmitted: onSearchSubmit,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.search),
                                labelText: 'Plant name',
                                helperStyle: TextStyle(height: 0.7),
                                errorStyle: TextStyle(height: 0.7),
                              ))),
                      const SizedBox(height: 20.0),
                    ],
                  )))));
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
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index];
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plants'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPlantPage(notifyParent: callback),
                ),
              ).then((value) {
                setState(() {
                  _futureLocations = _getLocations();
                  _futurePlants = _getPlants('');
                });
              });
            },
          ),
        ],
      ),
      drawer: DrawerNavigation(),
      body: Container(
        child: FutureBuilder<List<Location>>(
          future: _futureLocations,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildWidgets(snapshot.data);
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
