import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transport/home_page.dart';
import 'constants.dart';

class MyCard extends StatefulWidget {
  MyCard({Key? key}) : super(key: key);
  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  String name = '';
  String imageUrl = '';
  String myImageUrl = '';
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


  ////UPLOADING AND GETTING URL OF IMAGE
  Future<void> selectImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    String uniqueName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceImage = FirebaseStorage.instance.ref().child('images').child(uniqueName);
    try {
      await referenceImage.putFile(File(pickedImage!.path));
      imageUrl = await referenceImage.getDownloadURL();
    }
    catch(error){
      print('CANNOT UPLOAD IMAGE AND GET URL');
    }
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
          myImageUrl=doc.get('imageUrl');
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
      'Name': _nameController.text,
      'Time': int.parse(_timeController.text),
      'isMatched': false,
      'imageUrl' : imageUrl,
      'Uid': userUid,
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
              IconButton(
                  onPressed: (){selectImage();},
                  icon: const Icon(Icons.image_rounded)),
            ],
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
      child: Card(
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
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 80,
                        child: Image.network(myImageUrl),
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 0.6 * screenSize.width,
                            child: Text('Name: $name'),
                          ),
                          const SizedBox(height: 10,),
                          Text('Timing: $time'),
                          const SizedBox(height: 10,),
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
          )),
    );
  }
}
