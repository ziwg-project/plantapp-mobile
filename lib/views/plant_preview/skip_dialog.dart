import 'package:flutter/material.dart';

class SkipDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Skip action:'),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: const Text(
                'Cancel',
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
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
