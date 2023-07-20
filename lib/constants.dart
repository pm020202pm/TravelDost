import 'package:cloud_firestore/cloud_firestore.dart';
late String userUid;
late String userName;
late String userImageUrl;
bool myList=false;
bool isMyCardExpanded = false;
final List<String> hours = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12'
];
final List<String> minutes = [
  '00',
  '05',
  '10',
  '15',
  '20',
  '25',
  '30',
  '35',
  '40',
  '45',
  '50',
  '55',
];
final List<String> pmam = [
  'AM',
  'PM',
];
int selectedHour=0;
int selectedMinute=0;
int selectedPmAm=0;

Future<void> getUserImageUrlAndName() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('register').where('uid', isEqualTo: userUid).get();
  if (snapshot.size > 0) {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('register').doc(snapshot.docs[0].id).get();
    if (doc.exists) {

      doc.get('name');
      return doc.get('name');
    }
    else {
    }
  }
  else{
  }

}Future<String> getUserImageUrl() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('register').where('uid', isEqualTo: userUid).get();
  if (snapshot.size > 0) {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('register').doc(snapshot.docs[0].id).get();
    if (doc.exists) {
      return doc.get('imageUrl');
      return doc.get('imageUrl');
    }
    else {
      return ' ';
    }
  }
  else{
    return ' ';
  }
}

/////CHECK FOR MULTIPLE REQUEST FROM SINGLE USER
Future<bool> duplicates() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where("Uid", isEqualTo: userUid).get();
  if (querySnapshot.docs.isNotEmpty) {
    return true;
  }
  else {
    return false;
  }
}

////RETRIEVING DATA OF DOCUMENT EXCEPT USER's DOCUMENT



  /////TO MAP USERUID AND FCM AND STORE IN COLLECTION
  // Future<void> mapAndSendFCM() async {
  //   await FirebaseMessaging.instance.requestPermission();
  //   final fcm = await FirebaseMessaging.instance.getToken();
  //   print('FCM----KEY----IS----: $fcm');
  //   await FirebaseFirestore.instance.collection('fcm').add({
  //     'uid': userUid,
  //     'token': fcm,
  //   }).then((value) => print("fcm and uid added")).catchError((error) => print("Failed to fcm and uid: $error"));
  // }


/////FUNCTION TO SEND PUSH NOTIFICATION(not working)
// Future<void> sendPushNotificationToUser(String userFCMToken) async {
//   final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
//   const serverKey = 'AAAAFzcSkuA:APA91bEbiWfeD-bGp0qbBZ5oMF5IJyOKICMKJ4mGN1Gt-QBA7o3gQwQ1PhqvrC-pTO99_J_FQ4XiWjIYb1CSoj5NSJC10EenUMYKh4xnd09K1KE3S1CjEJJRBFecOq-0UxliqUAtEQ0l';
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'key=$serverKey',
//   };
//   print("YOUR FCM TOKENNNNNNNNNNNNNNNNNNNNNNN IS   : $userFCMToken");
//   final bodyData = {
//     'to': userFCMToken,
//     'notification': {
//       'title': 'New Request',
//       'body': 'Someone has requested to travel with you',
//     },
//   };
//   final response = await http.post(
//     url,
//     headers: headers,
//     body: json.encode(bodyData),
//   );
//   if (response.statusCode == 200) {
//     print('Push notification sent successfully.');
//   }
//   else {
//     print('Failed to send push notification. Error: ${response.statusCode}');
//   }
// }


////FUNCTION TO MATCH TWO COMMON FIELDS AND THEN STORE THAT DOC IN ANOTHER COLLECTION
// Future<void> acceptUsers () async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
//   List<QueryDocumentSnapshot> documents = querySnapshot.docs;
//   for (var document in documents) {
//     var itemTime = document['Time'];
//     var itemName = document['Name'];
//     for (var doc in documents) {
//       var dupTime = doc['Time'];
//       var dupName = doc['Name'];
//       if (itemTime == dupTime && itemName != dupName) {
//         QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance.collection('Accepted').where("Name", isEqualTo: dupName).get();
//         if(!querySnapshot2.docs.isNotEmpty) {
//           final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('Time', isEqualTo: dupTime).get();
//           await FirebaseFirestore.instance.collection('Accepted').add({
//           'Name': doc['Name'],
//           'Time': doc['Time'],
//           'isMatched' : true,
//         }).then((value) => print("User added")).catchError((error) => print("Failed to add user: $error"));
//           final batch = FirebaseFirestore.instance.batch();
//           querySnapshot.docs.forEach((doc) {
//             batch.delete(doc.reference);
//           });
//           // Commit the batch delete operation
//           await batch.commit();
//         }
//       }
//     }
//   }
// }


// Future<void> accept(int time, String name) async {
//   if (await duplicates() == false) {
//   await FirebaseFirestore.instance.collection('Accepted').add({
//   'Name': "${_nameController.text} accepted $name request!",
//   'Time': time,
//   'isMatched': true,
//   }).then((value) => print("User added")).catchError((error) => print("Failed to add user: $error"));
//   final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('Time', isEqualTo: time).get();
//   final batch = FirebaseFirestore.instance.batch();
//   querySnapshot.docs.forEach((doc) {
//   batch.delete(doc.reference);
//   });
//   await batch.commit();
//   }
//   Navigator.pop(context);
//   _nameController.clear();
// }

// void acceptDialog() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Enter details'),
//         content: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Your name please',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {Navigator.pop(context);},
//           ),
//           TextButton(
//             child: const Text('Submit'),
//             onPressed: () {accept(widget.time, widget.name);},
//           ),
//         ],
//       );
//     },
//   );
// }

// @override
// void initState() {
//   isRequestedUpdate();
//   super.initState();
// }
// Future<void> isRequestedUpdate () async {
//   QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance.collection('Users').get();
//   QuerySnapshot pendingQuerySnapshot = await FirebaseFirestore.instance.collection('pending').get();
//   List<QueryDocumentSnapshot> userDoc = userQuerySnapshot.docs;
//   List<QueryDocumentSnapshot> pendingDoc = pendingQuerySnapshot.docs;
//   for (var document in userDoc) {
//     for (var doc in pendingDoc) {
//       if(doc['senderUid']==userUid && document['Uid']==doc['receiverUid']){
//         FirebaseFirestore.instance.collection('Users').doc(document.id).update({
//           'isRequested': true,
//         }).then((value) {
//           print('Document updated successfully.');
//         }).catchError((error) {
//           print('Failed to update document: $error');
//         });
//       }
//     }
//   }
// }

// Future<List<QueryDocumentSnapshot>> fetchFirestoreDocuments() async {
//   final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('Uid', isNotEqualTo: userUid).get();
//   List<QueryDocumentSnapshot> documents = querySnapshot.docs;
//   return documents;
// }


// Future<void> getFCMByUid() async {
//   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('fcm').where('uid', isEqualTo: widget.cardUid).get();
//   if (snapshot.size > 0) {
//     DocumentSnapshot doc = await FirebaseFirestore.instance.collection('fcm').doc(snapshot.docs[0].id).get();
//     if (doc.exists) {
//       setState(() {
//         widget.otherFCM = doc.get('token');
//       });
//     }
//     else {
//       print('Document with ID does not exist.');
//     }
//   }
//   else {
//     print('no_doc');
//   }
// }




/////CREATE NEW REQUEST
// void newRequest() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       Size screenSize = MediaQuery.of(context).size;
//       return AlertDialog(
//         content: Container(
//          width: screenSize.width*0.6,
//          height: screenSize.height*0.4,
//           child: Column(
//             children: [
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Opacity(
//                     opacity: .5,
//                     child: Container(
//                       height: 32,
//                       width: 250,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[400],
//                           borderRadius: BorderRadius.circular(50)
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 71,
//                     width: 180,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ScrollHour(),
//                         const SizedBox(width: 20, child: Text(' :', style: TextStyle(fontSize: 24),),),
//                         ScrollMinute(),
//                         const SizedBox(width: 20,),
//                         ScrollPmAm(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20,),
//               CustomTextField(controller: fromController, obscureText: false, boxHeight: 35, hintText: 'From',),
//               const SizedBox(height: 10,),
//               CustomTextField(controller: toController, obscureText: false, boxHeight: 35, hintText: 'To',),
//               const SizedBox(height: 20,),
//               DropdownButton<String>(
//                 borderRadius: BorderRadius.circular(20),
//                 iconSize: 0,
//                 dropdownColor: Colors.grey[100],
//                 value: _selectedItem,
//                 elevation: 1,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedItem = newValue;
//                   });
//                   print(_selectedItem);
//                   },
//                 items: <String>['Mode', 'Auto', 'Bus', 'Car', 'Train', 'Flight'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Column(
//                       children: [
//                         Container(
//                             height: 35,
//                             width: 80,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.grey[200],
//                             ),
//                             child: Image.asset('assets/$value.png')
//                         ),
//                         const SizedBox(height: 2,)
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {Navigator.pop(context);},
//           ),
//           TextButton(
//             child: const Text('Submit'),
//             onPressed: () {
//               submitDetails();
//               },
//           ),
//
//         ],
//       );
//     },
//   );
// }
