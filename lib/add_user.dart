// import 'package:flutter/material.dart';
// import 'package:transport/user.dart';
//
// class AddUser extends StatefulWidget {
//   const AddUser({Key? key}) : super(key: key);
//
//   @override
//   State<AddUser> createState() => _AddUserState();
// }
//
// class _AddUserState extends State<AddUser> {
//   List<User> users = [];
//   void newUser() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         int userId=0;
//         return AlertDialog(
//           title: Text('New User'),
//           content: TextField(
//             decoration: InputDecoration(
//               labelText: 'User ID',
//             ),
//             onChanged: (value) {
//               userId = int.parse(value);
//             },
//             keyboardType: TextInputType.number,
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             TextButton(
//               child: Text('Submit'),
//               onPressed: () {
//                 setState(() {
//                   users.add(User(time: userId));
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
