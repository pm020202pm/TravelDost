import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:TravelDost/constants.dart';
import '../Components/button.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  TextEditingController feedbackController = TextEditingController();
  bool isFeedbackexpanded = false;

  Future<void> submitFeedback() async {
    await FirebaseFirestore.instance.collection('feedback').add({
      'Name': userName,
      'Uid': userUid,
      'feedback' : feedbackController.text,
    });
    feedbackController.clear();
    setState(() {
      isFeedbackexpanded = false;
    });
  }

  Future<void> deleteFCM() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('fcm').where('uid', isEqualTo: userUid).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        var bookDocument = querySnapshot.docs.first;
        await bookDocument.reference.delete();
        print('FCM DELETED SUCCESSFULLY');
      }else {
        print('CAN NOT DELETE FCM');
      }
    } catch (e) {
      print('CAN NOT FIND DOC TO DELETE FCM');
    }
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Logged out');
      await deleteFCM();
      Navigator.pushReplacementNamed(context, '/loginpage');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80,),
          CircleAvatar(
            radius: 80,
            foregroundImage: NetworkImage(userImageUrl),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            userName.toUpperCase(),
            style: const TextStyle(fontSize: 23),
          ),
          const SizedBox(
            height: 40,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: isFeedbackexpanded? 100: 0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 2, color: Colors.blue.shade200)
            ),
            child: TextField(
              maxLines: 4,
              controller: feedbackController,
              decoration: const InputDecoration(
                hintText: 'Write your feedback here',
                hintStyle: TextStyle(fontSize: 13),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0,),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0,),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
            isFeedbackexpanded
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  buttonText: 'Cancel' ,
                  textColor: Colors.red,
                  buttonBgColor: Colors.red[100],
                  onPressed: () {setState(() {
                    isFeedbackexpanded=false;
                  });},
                  height: 40, width: 80, borderRadius: 15,
                  splashColor: Colors.red[200],
                ),
                SizedBox(width: 30,),
                Button(
                  buttonText: 'Submit' ,
                  textColor: Colors.green,
                  buttonBgColor: Colors.green[100],
                  onPressed: () {setState(() {
                    submitFeedback();
                  });},
                  height: 40, width: 80, borderRadius: 15,
                  splashColor: Colors.red[200],
                ),
              ],
            )
           : Button(
        buttonText: 'Feedback',
        textColor: Colors.grey[100],
        buttonBgColor: Colors.grey[400],
            onPressed: () {setState(() {
    isFeedbackexpanded = true;
    });},
        height: 50,
        width: screenSize.width * 0.9,
        borderRadius: 15,
        fontSize: 21,
        fontWeight: FontWeight.w500,
        splashColor: Colors.blue[400],
    ),
          const SizedBox(height: 20,),
          Button(
            buttonText: 'Logout',
            textColor: Colors.grey[100],
            buttonBgColor: Colors.grey[400],
            onPressed: () {
              logout();
            },
            height: 50,
            width: screenSize.width * 0.9,
            borderRadius: 15,
            fontSize: 21,
            fontWeight: FontWeight.w500,
            splashColor: Colors.red[400],
          ),
        ]),
      ),
    );
  }
}
