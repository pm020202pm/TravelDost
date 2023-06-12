import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transport/user_card.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<List<QueryDocumentSnapshot>> fetchFirestoreDocuments() async {
  QuerySnapshot querySnapshot = await firestore.collection('Users').get();
  // Access the documents in the query snapshot
  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  return documents;
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: fetchFirestoreDocuments(),
      builder: (BuildContext context,
          AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { return const CircularProgressIndicator(); }
        if (snapshot.hasError) {return Text('Error: ${snapshot.error}');}
        List<QueryDocumentSnapshot> documents = snapshot.data!;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            var name = documents[index].get('Name');
            var time = documents[index].get('Time');
            var isMatched = documents[index].get('isMatched');
            // Display the data in your desired format
             return UserCard(color: isMatched? Colors.green : null, name: name, time: time, isMatched: false,);
          },
        );
      },
    );
  }
}
