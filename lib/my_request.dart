import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class MyCard extends StatefulWidget {
  MyCard({Key? key}) : super(key: key);
  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  String name = '';
  late int time = 0;
  late String deleteID;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  Future<void> getDocumentIdByFieldValue() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Uid', isEqualTo: userUid)
        .get();

    if (snapshot.size > 0) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot.docs[0].id)
          .get();
      if (doc.exists) {
        setState(() {
          name = doc.get('Name');
          time = doc.get('Time');
          deleteID = doc.id;
        });
      } else {
        print('Document with ID does not exist.');
      }
    } else {
      print('no_doc');
    }
  }

  @override
  void initState() {
    getDocumentIdByFieldValue();
    super.initState();
  }

  void newUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter details'),
          content: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                if (await duplicates() == false) {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .add({
                    'Name': _nameController.text,
                    'Time': int.parse(_timeController.text),
                    'isMatched': false,
                    'Uid': userUid,
                  })
                      .then((value) => print("User added"))
                      .catchError(
                          (error) => print("Failed to add user: $error"));
                  Navigator.pop(context);
                }
                _nameController.clear();
                _timeController.clear();
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
      child: Card(
          // color: color,
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (name == '')
            ? SizedBox(
          width: 0.9*screenSize.width,
              child: Column(
                children: [
                  IconButton(onPressed: () { newUser(); }, icon: const Icon(Icons.add),),
                  const Text('Create new request')
                ],
              ),
            )
            : Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 80,
                    child: Image.asset('assets/avatar.png'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 0.6 * screenSize.width,
                        child: Text('Name: $name'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Timing: $time'),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red[100],
                            ),
                            child: TextButton(
                                onPressed: () {
                                  deleteContact(deleteID);
                                },
                                child: const Text("Delete")),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
      )),
    );
  }
}
