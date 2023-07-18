import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/Components/user_card.dart';
import 'constants.dart';

class PendingTab extends StatefulWidget {
  const PendingTab({super.key});
  @override
  _PendingTabState createState() => _PendingTabState();
}

class _PendingTabState extends State<PendingTab> {

  Future<List<QueryDocumentSnapshot>> fetchRequestsDocuments() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('pending').where('senderUid', isEqualTo: userUid).get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    return documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: fetchRequestsDocuments(),
      builder: (BuildContext context,
          AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { return const Text("Loading..."); }
        if (snapshot.hasError) {return Text('Error: ${snapshot.error}');}
        List<QueryDocumentSnapshot> documents = snapshot.data!;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            var name = documents[index].get('name');
            var time = documents[index].get('time');
            var imageUrl = documents[index].get('imageUrl');
            var isAccepted = documents[index].get('isAccepted');
            return UserCard(name: name, time: time, isRequested: true, imageUrl:imageUrl, cardUid: '', otherFCM: '', isAccepted: isAccepted,);
          },
        );
      },
    );
  }
}
