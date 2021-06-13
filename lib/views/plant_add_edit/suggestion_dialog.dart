import 'package:flutter/material.dart';
import 'package:plants_app/models/suggestion_model.dart';
import 'package:plants_app/utils.dart';

class SuggestionDialog extends StatefulWidget {
  final String photoPath;

  SuggestionDialog({Key key, @required this.photoPath}) : super(key: key);

  @override
  _SuggestionDialogState createState() => _SuggestionDialogState(photoPath);
}

class _SuggestionDialogState extends State<SuggestionDialog> {
  String photoPath;
  Future<Widget> _futureWidget;
  _SuggestionDialogState(this.photoPath);

  @override
  void initState() {
    super.initState();
    _futureWidget = _buildList();
  }

  Widget _buildItem(Suggestion suggestion) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, suggestion);
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    suggestion.scientificName == null
                        ? ''
                        : suggestion.scientificName,
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    suggestion.probability == null
                        ? ''
                        : suggestion.probability,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> _buildList() async {
    String token = await getToken();
    List<Suggestion> suggestions = await fetchSuggestions(photoPath, token);
    if (suggestions.isNotEmpty) {
      return Container(
        height: 400,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return _buildItem(suggestions[index]);
          },
        ),
      );
    }
    return Center(child: const Text('No suggestions found for this plant'));
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
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
          future: _futureWidget,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        Container(child: _buildButtons(context)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Suggestions'),
      children: <Widget>[
        Container(
          width: double.maxFinite,
          child: _buildWidgets(),
        ),
      ],
    );
  }
}
