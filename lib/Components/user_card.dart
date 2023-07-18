import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/home_page.dart';
import '../catalogue_tab.dart';
import '../constants.dart';
import 'button.dart';

class UserCard extends StatefulWidget {
  UserCard({Key? key, required this.name, required this.time, required this.isRequested, required this.imageUrl, required this.cardUid, required this.otherFCM, required this.isAccepted}) : super(key: key);

  final String name;
  final int time;
  final bool isRequested;
  final bool isAccepted;
  final String imageUrl;
  final String cardUid;
  late final String otherFCM;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late String senderName;
  late String receiverName;
  late String receiverUid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<void> cancelRequest() async {
    QuerySnapshot querySnapshot1 = await firestore.collection('pending').where('receiverUid', isEqualTo: widget.cardUid).where('senderUid', isEqualTo: userUid).get();
    querySnapshot1.docs.forEach((document) {
      document.reference.delete();
    });
    QuerySnapshot querySnapshot = await firestore.collection('requests').where('receiverUid', isEqualTo: widget.cardUid).where('senderUid', isEqualTo: userUid ).get();
    querySnapshot.docs.forEach((document) {
      document.reference.delete();
    });
    print('CANCEL REQUEST BUTTON');
    print('receiver : ${widget.cardUid}');
    print('sender : $userUid');
    Navigator.pushNamed(context, '/homepage');
  }

  void congratulationDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 120,
            width: 150,
            child: Column(
              children: [
                Image.asset('assets/check.png', height: 75,),
                SizedBox(height: 20,),
                const Text('Request sent successfully !')
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getSenderName() async {
    QuerySnapshot snapshot = await firestore.collection('register').where('uid', isEqualTo: userUid).get();
    if (snapshot.size > 0) {
      DocumentSnapshot doc = await firestore.collection('register').doc(snapshot.docs[0].id).get();
      if (doc.exists) {
        setState(() {
          senderName= doc.get('name');
        });
      }
      else {
        print('SENDER NAME NOT FOUND');
      }
    }
    else {
      print('NO DOC IN REGISTER FOUND!');
    }
  }

  Future<void> sendRequest() async {
    QuerySnapshot requestQuerySnapshot = await firestore.collection('requests').where('senderUid', isEqualTo: userUid).where('receiverUid', isEqualTo: widget.cardUid).limit(1).get();
    if (requestQuerySnapshot.docs.isNotEmpty) {
      print('DOCUMENT ALREADY IN REQUESTS DATABASE');
    }
    else {
      await firestore.collection('requests').add({
        'senderName': senderName,
        'senderUid': userUid,
        'receiverUid' : widget.cardUid,
        'time' : widget.time,
      }).then((value) => print("REQUEST SENT SUCCESSFULLY")).catchError((error) => print("REQUEST SENT FAILED: $error"));
    }
    QuerySnapshot pendingQuerySnapshot = await firestore.collection('pending').where('senderUid', isEqualTo: userUid).where('receiverUid', isEqualTo: widget.cardUid).limit(1).get();
    if (pendingQuerySnapshot.docs.isNotEmpty) {
      print('DOCUMENT ALREADY IN PENDING DATABASE');
    }
    else {
      await firestore.collection('pending').add({
        'senderUid': userUid,
        'receiverUid' : widget.cardUid,
        'time' : widget.time,
        'name' : widget.name,
        'imageUrl' : widget.imageUrl,
        'isAccepted' : false,
      }).then((value) => print("PENDING CARD CREATED SUCCESSFULLY")).catchError((error) => print("PENDING CREATION FAILED: $error"));
    }
    congratulationDialog();
    Future.delayed(Duration(milliseconds: 1200), (){Navigator.pushNamed(context, '/homepage');});

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: screenSize.width*0.9,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(image:NetworkImage(widget.imageUrl), fit: BoxFit.fitWidth),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              const SizedBox(width: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 0.5*screenSize.width,child: Text('Name: ${widget.name}'),),
                  const SizedBox(height: 4,),
                  Text('Timing: ${widget.time}'),
                  const SizedBox(height: 4,),
                  (widget.isAccepted)
                      ? Button(buttonText: 'Accepted', textColor: Colors.green[700], buttonBgColor: Colors.green[200], onPressed: (){}, height: 32, width: 90,)
                      : Row(
                        children: [
                          Button(buttonText: (widget.isRequested)? 'Requested' : 'Request', textColor: (widget.isRequested)? Colors.grey[700]: Colors.blue, buttonBgColor:(widget.isRequested)? Colors.grey[350] : Colors.blue[100], onPressed: () async {if(widget.isRequested==false){await getSenderName(); sendRequest();} else{}}, height: 32, width: 90,),
                          const SizedBox(width: 10,),
                          if(widget.isRequested)Button(buttonText: 'Cancel' , textColor: Colors.red, buttonBgColor: Colors.red[100], onPressed: () {cancelRequest();}, height: 32, width: 80,),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
