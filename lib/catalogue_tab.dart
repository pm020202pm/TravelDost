import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/user_card.dart';
import 'constants.dart';
import 'my_request.dart';

class CatalogueTab extends StatefulWidget {
  const CatalogueTab({super.key});
  @override
  State<CatalogueTab> createState() => _CatalogueTabState();
}

class _CatalogueTabState extends State<CatalogueTab> {
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
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text('Others Request'),
          ),
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
              future: fetchFirestoreDocuments(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) { return const Text('Loading...'); }
                if (snapshot.hasError) {return Text('Error: ${snapshot.error}');}
                List<QueryDocumentSnapshot> documents = snapshot.data!;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    var name = documents[index].get('Name');
                    var time = documents[index].get('Time');
                    var isMatched = documents[index].get('isMatched');
                    var imageUrl = documents[index].get('imageUrl');
                    var uid = documents[index].get('Uid');
                    return UserCard(color: isMatched? Colors.green : null, name: name, time: time, isMatched: false, imageUrl: imageUrl, uid: uid,);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );;
  }
}