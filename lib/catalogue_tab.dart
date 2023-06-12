import 'package:flutter/material.dart';
import 'package:transport/fetch_firestore_data.dart';
import 'package:transport/user.dart';

class CatalogueTab extends StatelessWidget {
  final List<User> users;
  CatalogueTab({required this.users});
  @override
  Widget build(BuildContext context) {
    return MyWidget();
  }
}