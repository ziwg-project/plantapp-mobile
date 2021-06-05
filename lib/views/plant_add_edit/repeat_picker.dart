import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RepeatPicker extends StatefulWidget {
  final int durationIndex;
  final int intervalIndex;
  final Function(int newDuration, int newInterval) notifyParent;

  RepeatPicker({
    Key key,
    @required this.durationIndex,
    @required this.intervalIndex,
    @required this.notifyParent,
  }) : super(key: key);
  @override
  _RepeatPickerState createState() =>
      _RepeatPickerState(durationIndex, intervalIndex);
}

class _RepeatPickerState extends State<RepeatPicker> {
  final List<String> pickerList = [
    'Seconds',
    'Minutes',
    'Hours',
    'Days',
    'Weeks',
    'Months',
    'Years'
  ];
  int durationIndex;
  int intervalIndex;
  String repeatText;

  _RepeatPickerState(this.durationIndex, this.intervalIndex);

  Widget _buildStartPicker() {
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      child: CupertinoPicker(
        onSelectedItemChanged: (x) {},
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text('Every'),
          ),
        ],
        itemExtent: 40,
      ),
    );
  }

  Widget _buildDurationPicker() {
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: durationIndex),
        onSelectedItemChanged: (index) {
          setState(() {
            durationIndex = index;
            widget.notifyParent(durationIndex, intervalIndex);
          });
        },
        children: List.generate(
          60,
          (index) => Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text('${index + 1}'),
          ),
        ),
        itemExtent: 40,
      ),
    );
  }

  Widget _buildIntervalPicker() {
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: intervalIndex),
        onSelectedItemChanged: (index) {
          setState(() {
            intervalIndex = index;
            widget.notifyParent(durationIndex, intervalIndex);
          });
        },
        children: _buildIntervalList(),
        itemExtent: 40,
      ),
    );
  }

  List<Widget> _buildIntervalList() {
    List<Widget> list = [];
    for (int i = 0; i < pickerList.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            pickerList[i],
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildStartPicker(),
                  flex: 3,
                ),
                Expanded(child: _buildDurationPicker(), flex: 2),
                Expanded(child: _buildIntervalPicker(), flex: 4),
              ],
            )),
      ),
    );
  }
}
