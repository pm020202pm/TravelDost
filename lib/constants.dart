import 'package:cloud_firestore/cloud_firestore.dart';

late String userUid;
bool myList=false;
Future<bool> duplicates() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where("Uid", isEqualTo: userUid)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    return true;
  }
  else {
    return false;
  }
}

Future<List<QueryDocumentSnapshot>> fetchFirestoreDocuments() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
  // Access the documents in the query snapshot
  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  return documents;
}

void deleteContact(String documentId) {
  FirebaseFirestore.instance.collection('Users').doc(documentId).delete()
      .then((value) {
    print('Contact deleted successfully.');
  })
      .catchError((error) {
    print('Failed to delete contact: $error');
  });
}

