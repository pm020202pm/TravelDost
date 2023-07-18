import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport/home_page.dart';
import '../Components/button.dart';
import '../constants.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /////GET USER IMAGE URL
  Future<void> getUserImageUrlAndName() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('register').where('uid', isEqualTo: userUid).get();
    if (snapshot.size > 0) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('register').doc(snapshot.docs[0].id).get();
      if (doc.exists) {
        setState(() {
          userImageUrl= doc.get('imageUrl');
          userName= doc.get('name');
        });
        print('USER IMAGE URL IS : $userImageUrl');
        print('USER NAME IS : $userName');
      }
      else {
        print('SENDER NAME NOT FOUND');
      }
    }
    else {
      print('NO DOC IN REGISTER FOUND!');
    }
  }

  /////SIGN IN WITH EMAIL AND PASSWORD
  void signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        setState(() {
          userUid=user.uid;
        });
        print('USER UID IS : $userUid');
        await getUserImageUrlAndName();
        if(await duplicates()){
          setState(() {
            myList=true;
          });
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
      }
      emailController.clear();
      passwordController.clear();
    }
    catch (e) {
      print('WRONG EMAIL OR PASSWORD');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 200),
          child: Center(
            child: Column(
                children: [
                  const Text('LOGIN HERE'),
                  const SizedBox(height: 30,),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue, width: 0,),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue, width: 1,),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue, width: 0,),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue, width: 1,),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Button(buttonText: 'Login', textColor: Colors.lightBlue, buttonBgColor: Colors.lightGreenAccent, onPressed:(){signInWithEmailAndPassword(emailController.text, passwordController.text);}, height: 50, width: screenSize.width*0.9,),
                  const SizedBox(height: 20,),
                  const Text('or'),
                  const SizedBox(height: 20,),
                  Button(buttonText: 'Register', textColor: Colors.lightBlue, buttonBgColor: Colors.lightGreenAccent, onPressed:(){Navigator.pushNamed(context, '/registerpage');}, height: 50, width: screenSize.width*0.9,),
                ],
              ),
          ),
        ),
      )
    );

  }
}
