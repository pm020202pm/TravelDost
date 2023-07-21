import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport/Components/custom_textfield.dart';
import '../Components/button.dart';
import '../constants.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /////GET USER IMAGE URL


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
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('register').where('uid', isEqualTo: userUid).get();
        if (snapshot.size > 0) {
          DocumentSnapshot doc = await FirebaseFirestore.instance.collection('register').doc(snapshot.docs[0].id).get();
          if (doc.exists) {
            setState(() {
              userName =doc.get('name');
              userImageUrl= doc.get('imageUrl');
            });
          }
          else {}
        }
        else{}
        print('USER UID IS : $userUid');
        print('USER NAME IS : $userName');
        print('USER Image IS : $userImageUrl');
        // await getUserImageUrlAndName();
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
                  CustomTextField(controller: emailController, obscureText: false, labelText: 'Email', boxHeight: 45, ),
                  const SizedBox(height: 14),
                  CustomTextField(controller: passwordController, obscureText: true, labelText: 'Password', boxHeight: 45, ),
                  const SizedBox(height: 30,),
                  Button(
                    buttonText: 'Login',
                    textColor: Colors.lightBlue,
                    buttonBgColor: Colors.lightGreenAccent,
                    onPressed:(){signInWithEmailAndPassword(emailController.text, passwordController.text);},
                    height: 45, width: screenSize.width*0.9, borderRadius: 15,
                    splashColor: Colors.green[500],
                  ),
                  const SizedBox(height: 20,),
                  const Text('or'),
                  const SizedBox(height: 20,),
                  Button(
                    buttonText: 'Register',
                    textColor: Colors.lightBlue,
                    buttonBgColor: Colors.lightGreenAccent,
                    onPressed:(){Navigator.pushReplacementNamed(context, '/registerpage');},
                    height: 45, width: screenSize.width*0.9, borderRadius: 15,
                    splashColor: Colors.green[500],
                  ),
                ],
              ),
          ),
        ),
      )
    );

  }
}
