import 'package:flutter/material.dart';

import '../constants.dart';

class ScrollHour extends StatefulWidget {
  ScrollHour({super.key});
  @override
  _ScrollHourState createState() => _ScrollHourState();
}
class _ScrollHourState extends State<ScrollHour> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 75,
      child: ListWheelScrollView(
        itemExtent: 25,
        diameterRatio: 1.1,
        physics: const FixedExtentScrollPhysics(),
        children: hours.map((item) {
          return Center(
            child: Text(
              item,
              style: const TextStyle(fontSize: 25),
            ),
          );
        }).toList(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedHour = index;
          });
        },
      ),
    );
  }
}

class ScrollMinute extends StatefulWidget {
  ScrollMinute({super.key});
  @override
  _ScrollMinuteState createState() => _ScrollMinuteState();
}
class _ScrollMinuteState extends State<ScrollMinute> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 75,
      child: ListWheelScrollView(
        itemExtent: 25,
        diameterRatio: 1.1,
        physics: const FixedExtentScrollPhysics(),
        children: minutes.map((item) {
          return Center(
            child: Text(
              item,
              style: const TextStyle(fontSize: 25),
            ),
          );
        }).toList(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedMinute = index;
          });
          print(minutes[selectedMinute]);
        },
      ),
    );
  }
}

class ScrollPmAm extends StatefulWidget {
  ScrollPmAm({super.key});
  @override
  _ScrollPmAmState createState() => _ScrollPmAmState();
}
class _ScrollPmAmState extends State<ScrollPmAm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 75,
      child: ListWheelScrollView(
        itemExtent: 25,
        diameterRatio: 1.1,
        physics: const FixedExtentScrollPhysics(),
        children: pmam.map((item) {
          return Center(
            child: Text(
              item,
              style: const TextStyle(fontSize: 25),
            ),
          );
        }).toList(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedPmAm = index;
          });
        },
      ),
    );
  }
}