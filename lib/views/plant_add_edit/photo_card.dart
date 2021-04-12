import 'package:flutter/material.dart';

class PhotoCard extends StatefulWidget {
  // For later: have existing picture path here?
  final bool addedPicture;

  PhotoCard({Key key, @required this.addedPicture}) : super(key: key);

  @override
  _PhotoCardState createState() => _PhotoCardState(addedPicture);
}

class _PhotoCardState extends State<PhotoCard> {
  bool addedPicture;

  _PhotoCardState(this.addedPicture);

  Widget _buildImage() {
    return addedPicture
        ? Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // Change to FileImage later
                image: NetworkImage(
                    "https://images.bunches.co.uk/products/large/cheese-plant-1.jpg"),
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)],
            ),
          )
        : Container(
            child: Icon(
              Icons.add_a_photo,
              size: 75.0,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open camera
        setState(() {
          // Check if a photo was taken, for now pretend it was
          // Remember photo path ?
          // For later: plant recognition - with filling proper info in form
          addedPicture = true;
        });
      },
      child: Container(
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: _buildImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
