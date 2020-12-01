import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/Events.dart';
import 'jsonHandler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    loadEvents();
    return MaterialApp(
      title: 'Hackaton',
      home: Events(),
    );
  }
}
