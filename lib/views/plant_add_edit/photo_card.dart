import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoCard extends StatefulWidget {
  final String photoPath;
  final Function(String path) notifyParent;

  PhotoCard({Key key, this.photoPath, @required this.notifyParent})
      : super(key: key);

  @override
  _PhotoCardState createState() => _PhotoCardState(photoPath);
}

class _PhotoCardState extends State<PhotoCard> {
  final picker = ImagePicker();
  String photoPath;
  bool addedNew = false;

  _PhotoCardState(this.photoPath);

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('From gallery'),
                onTap: () {
                  _getImage(true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  _getImage(false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _getImage(bool fromGallery) async {
    final pickedFile = fromGallery
        ? await picker.getImage(source: ImageSource.gallery)
        : await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        photoPath = pickedFile.path;
        addedNew = true;
        widget.notifyParent(photoPath);
      }
    });
  }

  Widget _buildImage() {
    return photoPath != null
        ? Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: addedNew
                    ? FileImage(File(photoPath))
                    : NetworkImage(photoPath),
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1.0)],
            ),
          )
        : Container(
            child: const Icon(
              Icons.add_a_photo,
              size: 75.0,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: Container(
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: const BoxDecoration(
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
