import 'package:flutter/material.dart';
import 'package:plants_app/models/location_model.dart';
import 'package:plants_app/utils.dart';
import 'package:plants_app/views/delete_dialog.dart';
import 'package:plants_app/views/locations_list/add_location_dialog.dart';
import 'package:plants_app/views/locations_list/edit_location_dialog.dart';

class LocationPage extends StatefulWidget {
  final bool fromList;

  LocationPage({Key key, @required this.fromList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _LocationPageState(fromList);
}

class _LocationPageState extends State<LocationPage> {
  bool fromList;
  List<Widget> items = [];
  Future<List<Widget>> _futureWidgets;

  _LocationPageState(this.fromList);

  @override
  void initState() {
    super.initState();
    _futureWidgets = _buildItems();
  }

  Future<List<Widget>> _buildItems() async {
    List<Widget> items = [];
    String token = await getToken();
    List<Location> locations = await fetchAllLocations(token);
    List<List<Widget>> specificLocations =
        await _buildSpecificLocations(locations);
    for (int i = 0; i < 2; i++) {
      items.add(
        Card(
          child: ExpansionTile(
            title: Text(
              i == 0 ? 'Inside' : 'Outside',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            initiallyExpanded: true,
            children: specificLocations[i],
          ),
        ),
      );
    }
    return items;
  }

  Future<List<List<Widget>>> _buildSpecificLocations(
      List<Location> locations) async {
    List<Widget> inside = [];
    List<Widget> outside = [];
    for (int i = 0; i < locations.length; i++) {
      locations[i].type == 'I'
          ? inside.add(
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  fromList
                      ? _showPopupMenu(details.globalPosition, locations[i])
                      : Navigator.pop(
                          context, [locations[i].name, locations[i].id]);
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildLocationRow(locations[i]),
                  ),
                ),
              ),
            )
          : outside.add(
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  fromList
                      ? _showPopupMenu(details.globalPosition, locations[i])
                      : Navigator.pop(
                          context, [locations[i].name, locations[i].id]);
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildLocationRow(locations[i]),
                  ),
                ),
              ),
            );
    }
    return [inside, outside];
  }

  void _showPopupMenu(Offset offset, Location location) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Row(
            children: const <Widget>[
              Icon(Icons.edit),
              SizedBox(
                width: 5,
              ),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const <Widget>[
              Icon(Icons.delete),
              SizedBox(
                width: 5,
              ),
              Text('Delete'),
            ],
          ),
        ),
      ],
    ).then(
      (value) {
        if (value != null) {
          value == 0
              ? _editLocationDialog(context, location)
              : _askedToDelete(context, location);
        }
      },
    );
  }

  Widget _buildLocationRow(Location location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          location.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _askedToDelete(BuildContext context, Location location) async {
    final result = await showDialog(
        context: context, builder: (context) => DeleteDialog());
    if (result != null && result) {
      String token = await getToken();
      await deleteLocation(token, location.id.toString()).then((value) {
        setState(() {
          _futureWidgets = _buildItems();
        });
      });
    }
  }

  void _editLocationDialog(BuildContext context, Location location) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditLocationDialog(
        location: location,
      ),
    );
    if (result != null) {
      String token = await getToken();
      await updateLocation(token, location).then((value) {
        setState(() {
          _futureWidgets = _buildItems();
        });
      });
    }
  }

  void _addLocationDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => AddLocationDialog()).then((value) {
      setState(() {
        _futureWidgets = _buildItems();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fromList ? 'Locations' : 'Choose location'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _addLocationDialog(context);
        },
      ),
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
