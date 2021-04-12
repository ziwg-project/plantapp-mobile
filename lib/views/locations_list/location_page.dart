import 'package:flutter/material.dart';
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

  _LocationPageState(this.fromList);

  void _buildItems() {
    items.clear();
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
            children: _buildExpandedItems(),
          ),
        ),
      );
    }
  }

  List<Widget> _buildExpandedItems() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            // If fromList move to location edit
            fromList
                ? _editLocationDialog(context)
                : Navigator.pop(context, 'Chosen location');
          },
          onLongPress: () {
            _askedToDelete(context);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildLocationRow(),
            ),
          ),
        ),
      );
    }
    return list;
  }

  Widget _buildLocationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Location',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _askedToDelete(BuildContext context) async {
    final result = await showDialog(
        context: context, builder: (context) => DeleteDialog());
    if (result != null && result) {
      // Delete from database and refresh page
    }
  }

  void _editLocationDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditLocationDialog(
        mainLocation: 'Outside',
        locationName: 'Some location',
      ),
    );
    if (result != null) {
      // Edit database, refresh list
    }
  }

  void _addLocationDialog(BuildContext context) async {
    final result = await showDialog(
        context: context, builder: (context) => AddLocationDialog());
    if (result != null) {
      setState(() {
        // Rebuild list after adding a new location!
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildItems();
    return Scaffold(
      appBar: AppBar(
        title: Text(fromList ? 'Locations' : 'Choose location'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addLocationDialog(context);
        },
      ),
      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
        ),
      ),
    );
  }
}
