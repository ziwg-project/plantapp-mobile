import 'package:flutter/material.dart';

class DeleteDialog extends StatefulWidget {
  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Confirm deletion:'),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
