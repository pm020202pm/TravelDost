import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Travel', style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.w900, fontSize: 45,fontFamily: 'Aloevera',),),
        Column(
          children: [
            Text('Dost', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500,fontStyle: FontStyle.italic, fontSize: 32,fontFamily: 'Aloevera'),),
            SizedBox(height: 4,)
          ],
        ),
      ],
    );
  }
}
