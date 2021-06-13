import 'package:flutter/material.dart';
import 'package:plants_app/models/note_model.dart';
import 'package:plants_app/views/delete_dialog.dart';
import 'package:plants_app/views/plant_add_edit/edit_note_page.dart';
import '../../utils.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Function() notifyParent;

  NoteCard({Key key, @required this.note, @required this.notifyParent})
      : super(key: key);

  @override
  _NoteCardState createState() => _NoteCardState(note);
}

class _NoteCardState extends State<NoteCard> {
  Note note;

  _NoteCardState(this.note);

  List<Widget> _buildNoteInfo() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.note,
            size: 20.0,
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              note.text,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
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
              const Icon(Icons.edit),
              const SizedBox(
                width: 5,
              ),
              const Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              const Icon(Icons.delete),
              const SizedBox(
                width: 5,
              ),
              const Text('Delete'),
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
      String token = await getToken();
      await deleteNote(token, note.id.toString()).then((value) {
        widget.notifyParent();
      });
    }
  }

  void _editNote(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditNotePage(note: note),
        )).then((value) {
      widget.notifyParent();
    });
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
