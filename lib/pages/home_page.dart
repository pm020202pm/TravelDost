import 'package:flutter/material.dart';
import 'package:transport/Components/my_request_card.dart';
import 'package:transport/tabs/profile_tab.dart';
import '../tabs/home_tab.dart';
import '../tabs/pending_tab.dart';
import '../tabs/request_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  final screens = [
    MyRequestCard(),
    AcceptedTab(),
    PendingTab(),
    AboutPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(),
        child: NavigationBar(
          backgroundColor: Colors.grey[350],
          height: 65,
          selectedIndex: index,
          onDestinationSelected: (index) {
            setState(() {
              this.index = index;
            });
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(
                selectedIcon: Icon(Icons.people_alt_rounded),
                icon: Icon(Icons.people_alt_outlined), label: 'Requests'),
            NavigationDestination(
                icon: Icon(Icons.query_builder_sharp), label: 'Pending'),
            NavigationDestination(
                selectedIcon: Icon(Icons.account_circle),
                icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          ],
        ),
      ),
      // resizeToAvoidBottomInset: true,
      body: screens[index],
    );
  }
}
