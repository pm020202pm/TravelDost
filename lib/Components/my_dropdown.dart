import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? _selectedItem='Mode';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedItem,
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue;
        });
        print(_selectedItem);
      },
      items: <String>['Mode', 'Auto', 'Bus', 'Car', 'Train', 'Flight'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Column(
            children: [
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                  child: Image.asset('assets/$value.png')
              ),
              SizedBox(height: 7,)
            ],
          ),
        );
      }).toList(),
    );
  }
}
