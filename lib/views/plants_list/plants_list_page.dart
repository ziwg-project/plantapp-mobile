import 'package:flutter/material.dart';
import 'package:plants_app/views/plants_list/plants_list_card.dart';

class PlantsListPage extends StatefulWidget {
  @override
  _PlantsListPageState createState() => _PlantsListPageState();
}

class _PlantsListPageState extends State<PlantsListPage> {
  List<Widget> items = [];

  void _buildItems() {
    items.clear();
    for (int i = 0; i < 2; i++) {
      items.add(
        ExpansionTile(
          title: Text('Name',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          initiallyExpanded: true,
          children: _buildExpandedItems(),
        ),
      );
    }
  }

  List<Widget> _buildExpandedItems() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(
        PlantsListCard(),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _buildItems();
    return Scaffold(
      appBar: AppBar(
        title: Text('Plants'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            onPressed: () {},
          ),
        ],
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
