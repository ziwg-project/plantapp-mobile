import 'package:flutter/material.dart';

class PlantsListPage extends StatefulWidget {
  @override
  _PlantsListPageState createState() => _PlantsListPageState();
}

class _PlantsListPageState extends State<PlantsListPage> {
  List<Widget> items = [];

  void getItems() {
    for (int i = 0; i < 2; i++) {
      items.add(
        ExpansionTile(
          title: Text('Name',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          initiallyExpanded: true,
          children: getExpandedItems(),
        ),
      );
    }
  }

  List<Widget> getExpandedItems() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5.0)]),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Change to photo later
                  Icon(
                    Icons.photo,
                    size: 60.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Plant name',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    getItems();
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
