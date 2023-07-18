import 'package:flutter/material.dart';
import 'package:transport/pending_tab.dart';
import '../catalogue_tab.dart';
import '../request_tab.dart';
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
        body:  const TabBarView(
          children: [
            CatalogueTab(),
            AcceptedTab(),
            PendingTab(),
          ],
        ),
      ),
    );
  }
}
