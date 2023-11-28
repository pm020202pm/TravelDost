import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
late String userUid;
late String userName;
late String userImageUrl;
bool myList=false;
bool isMyCardExpanded = false;
final List<String> hours = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
final List<String> minutes = ['00', '05', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55',];
final List<String> pmam = ['AM', 'PM',];
int selectedHour=0;
int selectedMinute=0;
int selectedPmAm=0;

/////formatting date
String formatDateWithMonthInWords(DateTime date) {
  final formatter = DateFormat('dd MMM');
  return formatter.format(date);
}

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


  /////TO MAP USERUID AND FCM AND STORE IN COLLECTION
  Future<void> mapAndSendFCM() async {
    final fcm = await FirebaseMessaging.instance.getToken();
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('fcm').where('uid', isEqualTo: userUid).where('token', isEqualTo: fcm).limit(1).get();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('fcm').where('uid', isEqualTo: userUid).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference documentReference = querySnapshot.docs.first.reference;
      await documentReference.update({
        'token': fcm,
      });
      print('FCM UPDATED');
    }
    else {
      await FirebaseFirestore.instance.collection('fcm').add({
        'uid': userUid,
        'token': fcm,
      }).then((value) => print("fcm and uid added")).catchError((error) => print("Failed to fcm and uid: $error"));
    }
  }

  ///////request permission for notification
  void requestPermission() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if(settings.authorizationStatus == AuthorizationStatus.authorized){
    print("user granted permission");
  } else if(settings.authorizationStatus==AuthorizationStatus.provisional){
    print('user granted provisional permission');
  } else{
    print('user declined permission');
  }
}

  //////send notification body
  sendNotification(String title, body, to, icon) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "key=AAAAFzcSkuA:APA91bEbiWfeD-bGp0qbBZ5oMF5IJyOKICMKJ4mGN1Gt-QBA7o3gQwQ1PhqvrC-pTO99_J_FQ4XiWjIYb1CSoj5NSJC10EenUMYKh4xnd09K1KE3S1CjEJJRBFecOq-0UxliqUAtEQ0l",
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          "to": to,
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
            "android_channel_id": "basic",
            'image': icon,
          },
          "data": <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
            'image': icon,
            "url": icon,
          }
        },
      ),
    );
  } on Exception catch (e) {
    print(e);
  }
}


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
