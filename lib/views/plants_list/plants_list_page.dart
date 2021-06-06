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
  List<Plant> plants = [];
  Future<List<Widget>> _futureWidgets;

  @override
  void initState() {
    super.initState();
    getToken().then((value) => {
          fetchAllPlants(value, query: '').then((response) {
            plants = response;
          })
        });
    _futureWidgets = _buildWidgets();
  }

  final searchForm = FormGroup({
    'name': FormControl<String>(value: ''),
  });

  List<List<Widget>> _buildSpecificLocations(List<Location> locations) {
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

  @override
  void didUpdateWidget(PlantsListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      getToken().then((value) => {
            fetchAllPlants(value, query: '').then((response) {
              plants = response;
            })
          });
      searchForm.control('name').value = '';
      _futureWidgets = _buildWidgets();
    });
  }

  callback() {
    setState(() {
      searchForm.control('name').value = '';
      getToken().then((value) => {
            fetchAllPlants(value, query: '').then((response) {
              plants = response;
            })
          });
      _futureWidgets = _buildWidgets();
    });
  }

  onSearchSubmit() async {
    String token = await getToken();
    var response = await fetchAllPlants(token,
        query: this.searchForm.control('name').value);
    this.setState(() {
      plants = response;
      _futureWidgets = _buildWidgets();
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

  Future<List<Widget>> _buildWidgets() async {
    String token = await getToken();
    List<Widget> items = [];
    List<Location> locations = await fetchAllLocations(token);
    if (plants.isEmpty) {
      plants = await fetchAllPlants(token,
          query: this.searchForm.control('name').value);
    }
    List<List<Widget>> specificLocations = _buildSpecificLocations(locations);
    items.add(ReactiveForm(
        formGroup: this.searchForm,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
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
                  builder: (context) => AddPlantPage(notifyParent: callback),
                ),
              ).then((value) {
                setState(() {
                  getToken().then((value) => {
                        fetchAllPlants(value, query: '').then((response) {
                          plants = response;
                        })
                      });
                  _futureWidgets = _buildWidgets();
                });
              });
            },
          ),
        ],
      ),
      drawer: DrawerNavigation(),
      body: Container(
        child: FutureBuilder<List<Widget>>(
          future: _futureWidgets,
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
