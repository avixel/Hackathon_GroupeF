import 'package:flutter/material.dart';


class Event extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackaton',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hackaton'),
        ),
        body: Center(
          child: Text('Hackaton'),
        ),
      ),
    );
  }
}