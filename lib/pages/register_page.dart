import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Components/button.dart';
import '../constants.dart';

class RegisterUser extends StatefulWidget {
  RegisterUser({Key? key}) : super(key: key);
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String email;
  late String name;
  late String imageUrl = 'https://firebasestorage.googleapis.com/v0/b/traveldost-f6a2d.appspot.com/o/images%2Fprofile.jpg?alt=media&token=34c16029-42ff-4d31-8aba-f2e5f114f314';

  ////UPLOAD IMAGE AND GET URL
  Future<void> uploadImageGetUrl() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    String uniqueName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceImage = FirebaseStorage.instance.ref().child('images').child(uniqueName);
    try {
      await referenceImage.putFile(File(pickedImage!.path));
      setState(() async {
        imageUrl = await referenceImage.getDownloadURL();
      });
    }
    catch(error){
      print('CANNOT UPLOAD IMAGE AND GET URL');
    }
  }

  /////REGISTER WITH EMAIL AND PASSWORD
  void registerWithEmailAndPassword(String email, String password,  String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      await FirebaseFirestore.instance.collection('register').add({
        'email': email,
        'name': name,
        'uid' : user?.uid,
        'imageUrl' : imageUrl,
      }).then((value) => print("USER REGISTERED SUCCESSFULLY")).catchError((error) => print("REGISTRATION FAILED: $error"));
      if (user != null) {
        setState(() {
          userUid=user.uid;
          userImageUrl=imageUrl;
        });
        Navigator.pushNamed(context, '/homepage');
      }

    } catch (e) {
      // Handle registration failure
    }
    nameController.clear();
    emailController.clear();
    passwordController.clear();
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
                  const Text('REGISTER HERE'),
                  const SizedBox(height: 30,),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          foregroundImage: NetworkImage(imageUrl),
                        ),
                      ),
                      IconButton(onPressed: (){uploadImageGetUrl();}, icon: const Icon(Icons.camera_alt_rounded,size: 30,)),
                    ]
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
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
                    controller:passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Create a new password',
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
                  Button(buttonText: 'Register', textColor: Colors.lightBlue, buttonBgColor: Colors.lightGreenAccent, onPressed:(){registerWithEmailAndPassword(emailController.text, passwordController.text, nameController.text);}, height: 50, width: screenSize.width*0.9,),
                  const SizedBox(height: 20,),
                  const Text('or'),
                  const SizedBox(height: 20,),
                  Button(buttonText: 'Login', textColor: Colors.blue, buttonBgColor: Colors.lightGreenAccent, onPressed: (){Navigator.pushNamed(context, '/loginpage');}, height: 50, width: screenSize.width*0.9,)
                ],
              ),
            ),
          ),
        )
    );
  }
}


