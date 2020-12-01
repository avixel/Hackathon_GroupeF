import 'package:flutter/material.dart';
import 'jsonHandler.dart';

class Eventpage extends StatelessWidget {
  final Event event;

  Eventpage({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.titre),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(event.description),
      ),
    );
  }
}
