import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport/user.dart';
import 'accepted_tab.dart';
import 'catalogue_tab.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<User> users = [];

  Future<bool> duplicates () async {
    String itemName = _nameController.text;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where("Name", isEqualTo: itemName).get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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
              ),TextField(
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
                if(await duplicates()==false){
                  await FirebaseFirestore.instance.collection('Users').add({
                    'Name': _nameController.text,
                    'Time': int.parse(_timeController.text),
                    'isMatched': false,
                  }).then((value) => print("User added")).catchError((error) => print("Failed to add user: $error"));
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TravelDost'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Catalogue'),
              Tab(text: 'Accepted'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CatalogueTab(users: users),
            AcceptedTab(users: users),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: newUser,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}