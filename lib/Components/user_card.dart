import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/Components/Image_card.dart';
import '../constants.dart';
import 'button.dart';

class UserCard extends StatefulWidget {
  UserCard({Key? key, required this.name, required this.time, required this.isRequested, required this.imageUrl, required this.cardUid, required this.otherFCM, required this.isAccepted, required this.isDenied, required this.vehicle, required this.fromPlace, required this.toPlace, required this.message, required this.isMessage}) : super(key: key);

  final String name;
  final String time;
  final String fromPlace; final String vehicle; final String toPlace;
  late final bool isRequested;
  final bool isAccepted;
  final bool isDenied;
  final String imageUrl;
  final String cardUid;
  final String message;
  final bool isMessage;
  late final String otherFCM;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isExpanded=false;
  late String senderName;
  late String receiverName;
  late String receiverUid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isRequestedLocal=false;

  Future<void> cancelRequest() async {
    QuerySnapshot querySnapshot1 = await firestore.collection('pending').where('receiverUid', isEqualTo: widget.cardUid).where('senderUid', isEqualTo: userUid).get();
    querySnapshot1.docs.forEach((document) {
      document.reference.delete();
    });
    QuerySnapshot querySnapshot = await firestore.collection('requests').where('receiverUid', isEqualTo: widget.cardUid).where('senderUid', isEqualTo: userUid ).get();
    querySnapshot.docs.forEach((document) {
      document.reference.delete();
    });
    setState(() {
      isRequestedLocal=false;
    });
    if(widget.isRequested==true){
      Navigator.pushNamed(context, '/homepage');
    }
  }

  // void congratulationDialog(){
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: SizedBox(
  //           height: 120,
  //           width: 150,
  //           child: Column(
  //             children: [
  //               Image.asset('assets/check.png', height: 75,),
  //               const SizedBox(height: 20,),
  //               const Text('Request sent successfully !')
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
        'isAccepted' : false,
        'senderImageUrl': userImageUrl,
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
        'isDenied' : false,
      }).then((value) => print("PENDING CARD CREATED SUCCESSFULLY")).catchError((error) => print("PENDING CREATION FAILED: $error"));
    }
    setState(() {
      isRequestedLocal=true;
    });
    print('isRequested : ${widget.isRequested}');
    print('isRequestedLocal : $isRequestedLocal');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 80,),
              AnimatedContainer(
                width: screenSize.width*0.9,
                height: (isExpanded)? 90: 0,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20)
                ),
                duration: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('\n\nMessage : ${widget.message}'),
                ),
              ),
            ],
          ),
          AnimatedContainer(
              width: screenSize.width*0.9,
              height: 110,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 5.0),
                  ),
                ],
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)
              ),
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ImageCard(height: 70, width: 70, radius: 18, imageProvider: NetworkImage(widget.imageUrl),),
                    const SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${widget.name}'),
                            const SizedBox(height: 4,),
                            Text(widget.time),
                            Row(children: [
                              Text(widget.fromPlace, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),),
                              const SizedBox(width: 5,),
                              const Icon(Icons.linear_scale, color: Colors.grey),
                              const SizedBox(width: 5,),
                              Image.asset('assets/${widget.vehicle}.png', height: 18,),
                              const SizedBox(width: 5,),
                              const Icon(Icons.linear_scale, color: Colors.grey),
                              const SizedBox(width: 5,),
                              Text(widget.toPlace, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),),
                            ],),
                          ],
                        ),
                        if(widget.isAccepted && widget.isDenied==false)
                          Button(
                            buttonText: 'Accepted',
                            textColor: Colors.green[700],
                            buttonBgColor: Colors.green[200],
                            onPressed: (){},
                            height: 32, width: 90, borderRadius: 15,
                            splashColor: Colors.green[200],
                          )
                        else if(widget.isAccepted==false && widget.isDenied)
                          Button(
                            buttonText: 'Denied',
                            textColor: Colors.grey[700],
                            buttonBgColor: Colors.grey[300],
                            onPressed: (){},
                            height: 32, width: 90, borderRadius: 15,
                            splashColor: Colors.grey[300],
                          )
                        else
                          Row(
                            children: [
                              Button(
                                buttonText: (widget.isRequested || isRequestedLocal)? 'Requested' : 'Request',
                                textColor: (widget.isRequested || isRequestedLocal)? Colors.grey[700]: Colors.blue,
                                buttonBgColor:(widget.isRequested || isRequestedLocal)? Colors.grey[350] : Colors.blue[100],
                                onPressed: () async {if(widget.isRequested==false){await getSenderName(); sendRequest();} else{}},
                                height: 32, width: 80, borderRadius: 15,
                                splashColor: (widget.isRequested || isRequestedLocal)? Colors.grey[350] : Colors.blue[200],
                              ),
                              const SizedBox(width: 10,),
                              if(widget.isRequested || isRequestedLocal)
                                Button(
                                  buttonText: 'Cancel' ,
                                  textColor: Colors.red,
                                  buttonBgColor: Colors.red[100],
                                  onPressed: () {cancelRequest();},
                                  height: 32, width: 66, borderRadius: 15,
                                  splashColor: Colors.red[200],
                                ),
                              if(widget.isMessage)
                                Row(
                                  children: [
                                    const SizedBox(width: 10,),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 32,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2, color: Colors.lightGreen),
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                          onPressed: (){
                                            setState(() {
                                              isExpanded=!isExpanded;
                                            });
                                          },
                                          icon: Icon(Icons.message, color: Colors.green[800],size: 22,),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          )
                      ],
                    ),

                  ],
                ),
              )
          )
        ],
      )
    );
  }
}
