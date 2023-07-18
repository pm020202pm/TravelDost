
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transport/pages/register_page.dart';
import 'home_page.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: LoginPage(),
    );
  }
}


