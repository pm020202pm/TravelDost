import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
late String userUid;
// late String fcm;
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
Future<List<QueryDocumentSnapshot>> fetchFirestoreDocuments() async {
  final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('Uid', isNotEqualTo: userUid).get();
  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  return documents;
}


void deleteContact(String documentId) {
  FirebaseFirestore.instance.collection('Users').doc(documentId).delete().then((value) {
    print('Contact deleted successfully.');
  }).catchError((error) {
    print('Failed to delete contact: $error');
  });
}


  Future<void> mapAndSendFCM() async {
    await FirebaseMessaging.instance.requestPermission();
    final fcm = await FirebaseMessaging.instance.getToken();
    print('FCM----KEY----IS----: $fcm');
    await FirebaseFirestore.instance.collection('fcm').add({
      'uid': userUid,
      'token': fcm,
    }).then((value) => print("fcm and uid added")).catchError((error) => print("Failed to fcm and uid: $error"));
  }

Future<void> sendPushNotificationToUser(String userFCMToken) async {
  final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  const serverKey = 'AAAAFzcSkuA:APA91bEbiWfeD-bGp0qbBZ5oMF5IJyOKICMKJ4mGN1Gt-QBA7o3gQwQ1PhqvrC-pTO99_J_FQ4XiWjIYb1CSoj5NSJC10EenUMYKh4xnd09K1KE3S1CjEJJRBFecOq-0UxliqUAtEQ0l';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };
  print("YOUR FCM TOKENNNNNNNNNNNNNNNNNNNNNNN IS   : $userFCMToken");
  final bodyData = {
    'to': userFCMToken,
    'notification': {
      'title': 'New Request',
      'body': 'Someone has requested to travel with you',
    },
  };
  final response = await http.post(
    url,
    headers: headers,
    body: json.encode(bodyData),
  );
  if (response.statusCode == 200) {
    print('Push notification sent successfully.');
  }
  else {
    print('Failed to send push notification. Error: ${response.statusCode}');
  }
}
