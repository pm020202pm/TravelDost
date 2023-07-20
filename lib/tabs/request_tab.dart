import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Components/request_card.dart';
import '../constants.dart';

class AcceptedTab extends StatefulWidget {
  const AcceptedTab({super.key});
  @override
  State<AcceptedTab> createState() => _AcceptedTabState();
}

class _AcceptedTabState extends State<AcceptedTab> {
  Future<List<QueryDocumentSnapshot>> fetchRequestsDocuments() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('requests').where('receiverUid', isEqualTo: userUid).get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    return documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: fetchRequestsDocuments(),
      builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { return const Text("Loading..."); }
        if (snapshot.hasError) {return Text('Error: ${snapshot.error}');}
        List<QueryDocumentSnapshot> documents = snapshot.data!;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            var name = documents[index].get('senderName');
            var requestSender = documents[index].get('senderUid');
            var isAccepted = documents[index].get('isAccepted');
            var senderImageUrl = documents[index].get('senderImageUrl');
            return RequestCard(name: name, requestSender: requestSender, isAccepted: isAccepted, senderImageUrl: senderImageUrl);
          },
        );
      },
    );
  }
}
