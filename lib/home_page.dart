import 'package:flutter/material.dart';
import 'accepted_tab.dart';
import 'catalogue_tab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TravelDost'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Catalogue'),
              Tab(text: 'Accepted'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CatalogueTab(),
            AcceptedTab(),
          ],
        ),
      ),
    );
  }
}
