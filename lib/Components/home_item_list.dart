import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/Components/user_card.dart';
import '../constants.dart';

class HomeList extends StatelessWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 210,),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 0, 0),
          child: (isMyCardExpanded==false)? const Text('Others Request'): Container(),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').where('Uid', isNotEqualTo: userUid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) { return const Text("Loading..."); }
              if (snapshot.hasError) {return Text('Error: ${snapshot.error}');}
              List<DocumentSnapshot> userDocs = snapshot.data!.docs;
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('pending').get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) { return const Text("Loading..."); }
                  if (snapshot.hasError) {return Text('Error: ${snapshot.error}');}
                  List<DocumentSnapshot> pendingDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: userDocs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var name = userDocs[index]['Name'];
                      var imageUrl = userDocs[index]['imageUrl'];
                      var cardUid = userDocs[index]['Uid'];
                      var vehicle = userDocs[index]['mode'];
                      var hours = userDocs[index]['hours'];
                      var minute = userDocs[index]['minute'];
                      var pmam = userDocs[index]['pmam'];
                      var fromPlace = userDocs[index]['from'];
                      var toPlace = userDocs[index]['to'];
                      var message = userDocs[index]['message'];
                      var date = userDocs[index]['date'];

                      bool isRequested;
                      bool isAccepted;
                      bool isDenied;
                      bool isMessage;
                      var docIndex1 = pendingDocs.indexWhere((doc) => doc['receiverUid'] == cardUid && doc['senderUid']==userUid);
                      var docIndex2 = pendingDocs.indexWhere((doc) => doc['receiverUid'] == cardUid && doc['senderUid']==userUid && doc['isAccepted'] == true) ;
                      var docIndex3 = pendingDocs.indexWhere((doc) => doc['receiverUid'] == cardUid && doc['senderUid']==userUid && doc['isDenied'] == true) ;
                      if (docIndex1 != -1) {
                        isRequested = true;
                      } else {
                        isRequested = false;
                      }
                      if(docIndex2 != -1){
                        isAccepted = true;
                      } else{
                        isAccepted = false;
                      }
                      if(docIndex3 != -1){
                        isDenied = true;
                      } else{
                        isDenied= false;
                      }
                      if(message==''){
                        isMessage = false;
                      } else{
                        isMessage= true;
                      }
                      return UserCard(name: name, time: 'Leaving at $hours : $minute $pmam on $date', isRequested: isRequested, imageUrl: imageUrl, cardUid: cardUid, otherFCM: '', isAccepted: isAccepted, isDenied: isDenied, vehicle: vehicle, fromPlace: fromPlace, toPlace: toPlace, message: message, isMessage: isMessage,);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
