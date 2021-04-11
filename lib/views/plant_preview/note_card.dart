import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  List<Widget> _buildNoteInfo() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.note,
            size: 20.0,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Note name',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vehicula felis ac magna dapibus fermentum. Nam mattis lacinia tortor, blandit finibus orci elementum eu. Nam a elit sit amet sem hendrerit blandit in id velit.',
        style: const TextStyle(fontSize: 15),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: _buildNoteInfo(),
          ),
        ),
      ),
    );
  }
}
