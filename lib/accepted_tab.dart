import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/user_card.dart';

class AcceptedTab extends StatefulWidget {
  const AcceptedTab({super.key});
  @override
  _AcceptedTabState createState() => _AcceptedTabState();
}

class _AcceptedTabState extends State<AcceptedTab> {
  Future<List<QueryDocumentSnapshot>> fetchFirestoreDocuments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Accepted').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    return documents;
  }

  @override
  void initState() {
    super.initState();
    acceptUsers();
  }


  Future<void> acceptUsers () async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    for (var document in documents) {
      var itemTime = document['Time'];
      var itemName = document['Name'];
      for (var doc in documents) {
        var dupTime = doc['Time'];
        var dupName = doc['Name'];
        if (itemTime == dupTime && itemName != dupName) {
          QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance.collection('Accepted').where("Name", isEqualTo: dupName).get();
          if(!querySnapshot2.docs.isNotEmpty) {
            final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('Time', isEqualTo: dupTime).get();
            await FirebaseFirestore.instance.collection('Accepted').add({
            'Name': doc['Name'],
            'Time': doc['Time'],
            'isMatched' : true,
          }).then((value) => print("User added")).catchError((error) => print("Failed to add user: $error"));
            final batch = FirebaseFirestore.instance.batch();
            querySnapshot.docs.forEach((doc) {
              batch.delete(doc.reference);
            });
            // Commit the batch delete operation
            await batch.commit();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: fetchFirestoreDocuments(),
      builder: (BuildContext context,
          AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { return const Text("Loading..."); }
        if (snapshot.hasError) {return Text('Error: ${snapshot.error}');}
        List<QueryDocumentSnapshot> documents = snapshot.data!;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            var name = documents[index].get('Name');
            var time = documents[index].get('Time');
            return UserCard(color: Colors.green, name: name, time: time, isMatched: true, imageUrl: 'assets/avatar.png',);
          },
        );
      },
    );
  }
}
