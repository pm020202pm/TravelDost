import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/constants.dart';

class RequestCard extends StatefulWidget {
  RequestCard({Key? key, required this.name, required this.requestSender}) : super(key: key);
  final String name;
  final String requestSender;
  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {

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
        await documentReference.delete();
        print('REQUEST REMOVED SUCCESFULLY');
      } else {
        print('NO SUCH REQUEST FOUND TO REMOVE');
      }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 0.6*screenSize.width,child: Text(widget.name),),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green[100],
                            ),
                            child: TextButton(
                              onPressed: ()  {acceptRequest();},
                              child: const Text("Accept"),)
                        ),
                        const SizedBox(width: 15,),
                        Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red[100],
                            ),
                            child: TextButton(
                              onPressed: () async {},
                              child: const Text("Deny"),)
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
          )),
    );
  }
}
