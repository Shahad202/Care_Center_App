import 'package:flutter/material.dart';

class RenterPage extends StatefulWidget {
  final String userName;
  
  const RenterPage({super.key, required this.userName});

  @override
  State<RenterPage> createState() => _RenterPageState();
}

class _RenterPageState extends State<RenterPage> {
  @override
  Widget build(BuildContext context) {
    return Text('You are in Reservation Page');
  }
}
