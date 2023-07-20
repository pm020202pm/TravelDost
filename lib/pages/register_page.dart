
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transport/Components/Image_card.dart';
import 'package:transport/Components/custom_textfield.dart';
import 'dart:io';
import '../Components/button.dart';
import '../constants.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class RegisterUser extends StatefulWidget {
  RegisterUser({Key? key}) : super(key: key);
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String email;
  late String name;
  late String targetPath;
  late String imageUrl = ' ';
  File? compressedImageFile;

  ////UPLOAD IMAGE
  Future<void> uploadImageGetUrl() async {
    final XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      File compressedImage = await compressImage(imageFile.path);
      setState(() {
        compressedImageFile = compressedImage;
      });
      print("FILENAME ${compressedImage.path}");
    }

  }

  ////GET IMAGE URL
  Future<void> getImageUrl(File compressedImage) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('images').child(DateTime.now().microsecondsSinceEpoch.toString());
    UploadTask uploadTask = storageReference.putFile(compressedImage);
    String uploadedImageUrl = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      imageUrl = uploadedImageUrl;
    });
  }

  ////COMPRESS IMAGE BEFORE UPLOAD
  Future<File> compressImage(String imagePath) async {
    final appDir = await getApplicationSupportDirectory();
    final tempDir = Directory("${appDir.path}/temp");
    await tempDir.create(recursive: true);
    String fileName = path.basename(imagePath);
    File compressedImage = File('${tempDir.path}/img_$fileName');
    await FlutterImageCompress.compressAndGetFile(
      imagePath,
      compressedImage.path,
      quality: 20,
    );
    return compressedImage;
  }

  ////REGISTER USER
  void registerWithEmailAndPassword(String email, String password,  String firstName, String lastName) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await getImageUrl(compressedImageFile!);
      User? user = userCredential.user;
      await FirebaseFirestore.instance.collection('register').add({
        'email': email,
        'name': '$firstName $lastName',
        'uid' : user?.uid,
        'imageUrl' : imageUrl,
      }).then((value) => print("USER REGISTERED SUCCESSFULLY")).catchError((error) => print("REGISTRATION FAILED: $error"));
      if (user != null) {
        setState(() {
          userUid=user.uid;
          userImageUrl=imageUrl;
          userName = '$firstName $lastName';
        });
        print('USER UID IS : $userUid');
        print('USER IMAGE URL IS : $userImageUrl');
        print('USER NAME IS : $userName');
        Navigator.pushNamed(context, '/homepage');
      }

    } catch (e) {
      // Handle registration failure
    }
    nameController.clear();
    lastNameController.clear();
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
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: (compressedImageFile!=null)
                        ? Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageCard(height: 90, width: 90, radius: 50, imageProvider: FileImage(compressedImageFile!)),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(55),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 67,),
                              Column(
                                children: [
                                  const SizedBox(height: 67,),
                                  Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: IconButton(padding: EdgeInsets.zero, onPressed: () {uploadImageGetUrl();}, icon: const Icon(Icons.edit, size: 20, color: Colors.white,),)),
                                ],
                              ),
                            ],
                          ),
                        ])
                        : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                            color: Colors.grey[750],
                            onPressed: (){uploadImageGetUrl();},
                            icon: const Icon(Icons.add_a_photo_outlined,size: 40,))),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(child: CustomTextField(controller: nameController, labelText: 'First Name', obscureText: false, boxHeight: 45,)),
                      const SizedBox(width: 10,),
                      Expanded(child: CustomTextField(controller: lastNameController, labelText: 'Last Name', obscureText: false, boxHeight: 45,)),
                    ],
                  ),
                  const SizedBox(height: 14,),
                  CustomTextField(controller: emailController, labelText: 'Email', hintText: 'Create a new email id', obscureText: false, boxHeight: 45,),
                  const SizedBox(height: 14,),
                  CustomTextField(controller: passwordController, labelText: 'Password', hintText: 'Create a new password', obscureText: true, boxHeight: 45,),
                  const SizedBox(height: 30,),
                  Button(buttonText: 'Register', textColor: Colors.lightBlue, buttonBgColor: Colors.lightGreenAccent, onPressed:(){registerWithEmailAndPassword(emailController.text, passwordController.text, nameController.text, lastNameController.text);}, height: 50, width: screenSize.width*0.9, borderRadius: 15,),
                  const SizedBox(height: 20,),
                  const Text('or'),
                  const SizedBox(height: 20,),
                  Button(buttonText: 'Login', textColor: Colors.blue, buttonBgColor: Colors.lightGreenAccent, onPressed: (){Navigator.pushNamed(context, '/loginpage');}, height: 50, width: screenSize.width*0.9, borderRadius: 15,)
                ],
              ),
            ),
          ),
        )
    );
  }
}


