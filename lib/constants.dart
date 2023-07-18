import 'package:cloud_firestore/cloud_firestore.dart';
late String userUid;
late String userName;
late String userImageUrl;
bool myList=false;

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