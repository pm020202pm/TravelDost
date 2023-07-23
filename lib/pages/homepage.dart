import 'package:flutter/material.dart';
import 'package:TravelDost/Components/my_request_card.dart';
import '../tabs/home_tab.dart';
import '../tabs/pending_tab.dart';
import '../tabs/request_tab.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('TravelDost'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Requests'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyRequestCard(),
            AcceptedTab(),
            PendingTab(),
          ],
        ),
      ),
    );
  }
}
