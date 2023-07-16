import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class UserCard extends StatefulWidget {
  UserCard({Key? key, required this.name, required this.time, required this.color, required this.isMatched, required this.imageUrl}) : super(key: key);

  final String name;
  final int time;
  final MaterialColor? color;
  final bool isMatched;
  final String imageUrl;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final TextEditingController _nameController = TextEditingController();

  void newUser(int time, String name) {
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
                  labelText: 'Your name please',
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
                  await FirebaseFirestore.instance.collection('Accepted').add({
                        'Name': "${_nameController.text} accepted $name request!",
                        'Time': time,
                        'isMatched': true,
                      }).then((value) => print("User added")).catchError((error) => print("Failed to add user: $error"));
                  final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('Time', isEqualTo: time).get();
                  final batch = FirebaseFirestore.instance.batch();
                  querySnapshot.docs.forEach((doc) {
                    batch.delete(doc.reference);
                  });
                  await batch.commit();
                }
                Navigator.pop(context);
                _nameController.clear();

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
          color: widget.color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 80,
                  child: Image.network(widget.imageUrl),
                ),
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 0.6*screenSize.width,child: Text('Name: ${widget.name}'),),
                    const SizedBox(height: 10,),
                    Text('Timing: ${widget.time}'),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.isMatched ? Colors.green[100] : Colors.blue[100],
                          ),
                          child: TextButton(
                              onPressed: (){
                                if(widget.isMatched ==false){
                                  newUser(widget.time, widget.name);
                                }
                              },
                              child: widget.isMatched ? const Text("Accepted") : const Text("Accept")),
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
