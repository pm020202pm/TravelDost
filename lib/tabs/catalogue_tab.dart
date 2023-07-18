import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/Components/user_card.dart';

import '../Components/my_request.dart';
import '../constants.dart';


class CatalogueTab extends StatefulWidget {
  const CatalogueTab({super.key});
  
  @override
  State<CatalogueTab> createState() => _CatalogueTabState();
}

class _CatalogueTabState extends State<CatalogueTab> {

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


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text('My Request'),
              ),
              MyCard(),
            ],
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text('Others Request'),
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
                        var time = userDocs[index]['Time'];
                        var imageUrl = userDocs[index]['imageUrl'];
                        var cardUid = userDocs[index]['Uid'];
                        bool isRequested;
                        bool  isAccepted;
                        var docIndex1 = pendingDocs.indexWhere((doc) => doc['receiverUid'] == cardUid && doc['senderUid']==userUid);
                        var docIndex2 = pendingDocs.indexWhere((doc) => doc['receiverUid'] == cardUid && doc['senderUid']==userUid && doc['isAccepted'] == true) ;
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
                        return UserCard(name: name, time: time, isRequested: isRequested, imageUrl: imageUrl, cardUid: cardUid, otherFCM: '', isAccepted: isAccepted,);
                      },
                    );
                  },
                );
              },
            ),
            // FutureBuilder<List<QueryDocumentSnapshot>>(
            //   future: fetchFirestoreDocuments(),
            //   builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) { return const Text('Loading...'); }
            //     if (snapshot.hasError) {return Text('Error: ${snapshot.error}');}
            //     List<QueryDocumentSnapshot> documents = snapshot.data!;
            //     return ListView.builder(
            //       itemCount: documents.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         var name = documents[index].get('Name');
            //         var time = documents[index].get('Time');
            //         var imageUrl = documents[index].get('imageUrl');
            //         var cardUid = documents[index].get('Uid');
            //         var isRequested = documents[index].get('isRequested');
            //         return UserCard(name: name, time: time, isRequested: isRequested, imageUrl: imageUrl, cardUid: cardUid, otherFCM: '',);
            //       },
            //     );
            //   },
            // ),
          ),
        ],
      ),
    );;
  }
}