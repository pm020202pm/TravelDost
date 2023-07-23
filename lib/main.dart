import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:TravelDost/pages/home_page.dart';
import 'package:TravelDost/pages/register_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'constants.dart';
import 'pages/login_page.dart';

////////////////////////////////extra
Future<void> _firebaseMessagingBackgoundHandler(RemoteMessage message) async {
  log('Handling a background message ${message.messageId}');
}
////////////////////////////////extra ends

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //////////////////////////////////////extra
  await FirebaseMessaging.instance.getInitialMessage();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  log(
    (await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission())
        .toString(),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgoundHandler);
  ////////////////////////////////////extra ends
  // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin=false;
  checkIfLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if(user!=null && mounted){
        setState(() {
          isLogin= true;
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
      }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes:{
        '/homepage' : (context) => const MyHomePage(),
        '/registerpage' : (context) => RegisterUser(),
        '/loginpage' : (context) => LoginPage(),

      },
      title: 'TravelDost',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLogin? MyHomePage(): LoginPage(),
    );
  }
}


