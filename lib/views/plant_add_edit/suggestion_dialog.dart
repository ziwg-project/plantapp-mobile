import 'package:flutter/material.dart';
import 'package:plants_app/models/suggestion_model.dart';

class SuggestionDialog extends StatefulWidget {
  final String photoPath;

  SuggestionDialog({Key key, @required this.photoPath}) : super(key: key);

  @override
  _SuggestionDialogState createState() => _SuggestionDialogState(photoPath);
}

class _SuggestionDialogState extends State<SuggestionDialog> {
  String photoPath;
  _SuggestionDialogState(this.photoPath);

  Widget _buildItem(Suggestion suggestion) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(
            context, [suggestion.plantName, suggestion.scientificName]);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    suggestion.plantName == null ? '' : suggestion.plantName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    suggestion.scientificName == null
                        ? ''
                        : suggestion.scientificName,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> _buildList() async {
    List<Suggestion> suggestions = await fetchSuggestions(photoPath);
    if (suggestions.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return _buildItem(suggestions[index]);
        },
      );
    }
    return Center(child: Text('No suggestions found for this plant'));
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FutureBuilder<Widget>(
          future: _buildList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        _buildButtons(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Suggestions'),
      children: <Widget>[
        Container(
          width: double.maxFinite,
          child: _buildWidgets(),
        ),
      ],
    );
  }
}
