import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport/home_page.dart';
import 'constants.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /////REGISTER WITH EMAIL AND PASSWORD
  void registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
    } catch (e) {
      // Handle registration failure
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
        if(await duplicates()){
          setState(() {
            myList=true;
          });
        }
        print('MY LIST BOOL : $myList');
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
      }
    }
    catch (e) {
      print('Wrong Username or Password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 200),
        child: Center(
          child: Column(
              children: [
                TextField(controller: emailController,),
                const SizedBox(height: 30,),
                TextField(controller: passwordController,),
                TextButton(
                    onPressed: (){registerWithEmailAndPassword(emailController.text, passwordController.text);},
                    child: const Text('Register')
                ),
                TextButton(
                    onPressed: (){signInWithEmailAndPassword(emailController.text, passwordController.text);},
                    child: const Text('Login')
                ),
              ],
            ),
        ),
      )
    );

  }
}
