import 'package:cloud_firestore/cloud_firestore.dart';

late String userUid;
bool myList=false;

/////CHECK FOR MULTIPLE REQUEST FROM SINGLE USER
Future<bool> duplicates() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where("Uid", isEqualTo: userUid).get();
  if (querySnapshot.docs.isNotEmpty) {
    return true;
  }
  else {
    return false;
  }
}

////RETRIEVING DATA OF DOCUMENT EXCEPT USER's DOCUMENT
Future<List<QueryDocumentSnapshot>> fetchFirestoreDocuments() async {
  final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('Uid', isNotEqualTo: userUid).get();
  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  return documents;
}


void deleteContact(String documentId) {
  FirebaseFirestore.instance.collection('Users').doc(documentId).delete().then((value) {
    print('Contact deleted successfully.');
  }).catchError((error) {
    print('Failed to delete contact: $error');
  });
}


