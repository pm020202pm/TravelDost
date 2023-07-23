import 'package:TravelDost/Components/my_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:TravelDost/constants.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'Image_card.dart';
import 'button.dart';

class RequestCard extends StatefulWidget {
  RequestCard({Key? key, required this.name, required this.requestSender, required this.isAccepted, required this.senderImageUrl}) : super(key: key);
  final String name;
  final String requestSender;
  final bool isAccepted;
  final String senderImageUrl;
  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {

  bool isAcceptedLocal=false;

  Future<void> acceptRequest() async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pending').where('senderUid', isEqualTo: widget.requestSender).where('receiverUid', isEqualTo: userUid).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference = querySnapshot.docs.first.reference;
        await documentReference.update({
          'isAccepted': true,
        });
        print('ACCEPTED REQUEST SUCCESSFULLY');
      } else {
        print('CANNOT ACCEPT REQUEST, SENDER IS NOT IN PENDING DATABASE');
      }

      QuerySnapshot requestsQuerySnapshot = await FirebaseFirestore.instance.collection('requests').where('senderUid', isEqualTo: widget.requestSender).where('receiverUid', isEqualTo: userUid).limit(1).get();
      if (requestsQuerySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference = requestsQuerySnapshot.docs.first.reference;
        await documentReference.update({
          'isAccepted': true,
        });
      } else {
        print('NO SUCH REQUEST FOUND TO REMOVE');
      }
      setState(() {
        isAcceptedLocal=true;
      });
  }

  Future<void> denyRequest() async {
    QuerySnapshot requestsQuerySnapshot = await FirebaseFirestore.instance.collection('requests').where('senderUid', isEqualTo: widget.requestSender).where('receiverUid', isEqualTo: userUid).limit(1).get();
    if (requestsQuerySnapshot.docs.isNotEmpty) {
      await requestsQuerySnapshot.docs.first.reference.delete();
      print('REQUEST DENIED SUCCESSFULLY');
    } else {
      print('NO SUCH REQUEST FOUND TO DENY');
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pending').where('senderUid', isEqualTo: widget.requestSender).where('receiverUid', isEqualTo: userUid).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference documentReference = querySnapshot.docs.first.reference;
      await documentReference.update({
        'isDenied': true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
          width: screenSize.width*0.9,
          height: 62,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12)
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ImageCard(height: 50, width: 50, radius: 10, imageProvider: NetworkImage(widget.senderImageUrl),),
                    const SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 0.3*screenSize.width,child: Text('${widget.name.toUpperCase()}', style: TextStyle(fontSize: 11, color: Colors.grey[800], fontWeight: FontWeight.w600),),),
                        SizedBox(width: 0.3*screenSize.width,child: Text('is requesting to travel with you', style: TextStyle(fontSize: 11, color: Colors.grey[700]),),),
                      ],
                    ),
                  ],
                ),

                (widget.isAccepted || isAcceptedLocal)
                ? Button(
                  buttonText: 'You Accepted',
                  textColor: Colors.green[900],
                  buttonBgColor: Colors.green[100],
                  onPressed: ()  {},
                  height: 30, width: 120, borderRadius: 15,
                  splashColor: Colors.green[100],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyIconButton(
                      buttonBgColor: Colors.red[100],
                      iconColor: Colors.red[800],
                      splashColor: Colors.red[200],
                        onPressed: () {denyRequest();},
                        iconSize: 25, height: 40, width: 50, borderRadius: 20,
                        icon: Icons.clear
                    ),
                    const SizedBox(width: 10,),
                    MyIconButton(
                      buttonBgColor: Colors.green[100],
                      iconColor: Colors.green[800],
                      splashColor: Colors.green[200],
                        onPressed: ()  {acceptRequest();},
                        iconSize: 25, height: 40, width: 50, borderRadius: 20,
                        icon: Icons.check,
                    ),

                    // Button(
                    //   buttonText: 'Accept',
                    //   textColor: Colors.blue[900],
                    //   buttonBgColor: Colors.blue[100],
                    //   onPressed: ()  {acceptRequest();},
                    //   height: 40, width: 70, borderRadius: 15,
                    //   splashColor: Colors.blue[200],
                    // ),
                    // const SizedBox(width: 10,),
                    // Button(
                    //   buttonText: 'Deny',
                    //   textColor: Colors.red[900],
                    //   buttonBgColor: Colors.red[100],
                    //   onPressed: ()  {denyRequest();},
                    //   height: 40, width: 70, borderRadius: 15,
                    //   splashColor: Colors.red[200],
                    // ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
