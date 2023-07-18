import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/home_page.dart';
import '../constants.dart';


class MyCard extends StatefulWidget {
  MyCard({Key? key}) : super(key: key);
  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  String name = '';
  String imageUrl = '';
  bool isDeleted=false;
  late int time = 0;
  late String deleteID;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    getDocumentIdByFieldValue();
    super.initState();
  }
  /////TO DELETE A REQUEST
  Future<void> deleteCard(String documentId) async {
    FirebaseFirestore.instance.collection('Users').doc(documentId).delete().then((value) {
      print('CARD DELETED SUCCESSFULLY');
    }).catchError((error) {
      print('FAILED TO DELETE CARD: $error');
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('requests').where('receiverUid', isEqualTo: userUid).get();
    querySnapshot.docs.forEach((document) {
      document.reference.delete();
    });
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance.collection('pending').where('receiverUid', isEqualTo: userUid).get();
    querySnapshot1.docs.forEach((document) {
      document.reference.delete();
    });
  }

  /////RETRIEVING DATA OF A SPECIFIC DOCUMENT
  Future<void> getDocumentIdByFieldValue() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users').where('Uid', isEqualTo: userUid).get();
    if (snapshot.size > 0) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(snapshot.docs[0].id).get();
      if (doc.exists) {
        setState(() {
          name = doc.get('Name');
          time = doc.get('Time');
          deleteID = doc.id;
          // myImageUrl=doc.get('imageUrl');
        });
      }
      else {
        print('Document with ID does not exist.');
      }
    }
    else {
      print('no_doc');
    }
  }

  /////SUBMIT DETAILS
  Future<void> submitDetails() async {
    await FirebaseFirestore.instance.collection('Users').add({
      'Name': userName,
      'Time': int.parse(_timeController.text),
      'Uid': userUid,
      'imageUrl' : userImageUrl,
      'isRequested': false,
    }).then((value) => print("User added")).catchError((error) => print("Failed to add user: $error"));
    Navigator.pop(context);
    _nameController.clear();
    _timeController.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
  }

  /////CREATE NEW REQUEST
  void newRequest() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter details'),
          content: TextField(
            controller: _timeController,
            decoration: const InputDecoration(
              labelText: 'Time',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {Navigator.pop(context);},
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                submitDetails();
                },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: screenSize.width*0.9,
        height: 90,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (name == '')
              ? SizedBox(
                  width: 0.9*screenSize.width,
                  child: Column(
                    children: [
                      IconButton(onPressed: () { newRequest(); }, icon: const Icon(Icons.add),),
                      const Text('Create a new request')
                    ],
                  ),
              )
              : Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(image:NetworkImage(userImageUrl), fit: BoxFit.fitWidth),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 0.5* screenSize.width,
                          child: Text('Name: $name'),
                        ),
                        const SizedBox(height: 4,),
                        Text('Timing: $time'),
                        const SizedBox(height: 4,),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red[100],
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    deleteCard(deleteID);
                                    setState(() {
                                     name='';
                                    });
                                    },
                                  child: const Text("Delete")),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
