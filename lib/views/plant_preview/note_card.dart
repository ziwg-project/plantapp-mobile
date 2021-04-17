import 'package:flutter/material.dart';
import 'package:plants_app/views/delete_dialog.dart';

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

  void _showPopupMenu(Offset offset, BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Row(
            children: <Widget>[
              Icon(Icons.edit),
              const SizedBox(
                width: 5,
              ),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              const SizedBox(
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
          value == 0 ? _editNote(context) : _askedToDelete(context);
        }
      },
    );
  }

  void _askedToDelete(BuildContext context) async {
    final result = await showDialog(
        context: context, builder: (context) => DeleteDialog());
    if (result != null && result) {
      // Delete from database and refresh page
    }
  }

  void _editNote(BuildContext context) async {
    // Push to edit page, get results
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _showPopupMenu(details.globalPosition, context);
      },
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
