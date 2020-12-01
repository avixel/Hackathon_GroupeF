import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/DataBase.dart';
import 'jsonHandler.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

class Eventpage extends StatefulWidget {
  final Event event;

  Eventpage({Key key, @required this.event}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<Eventpage> {
  var rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.titre),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Text(widget.event.description),
            SmoothStarRating(
              rating: rating,
              isReadOnly: false,
              size: 50,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
              onRated: (value) {
                addRating("a", value, widget.event.titre);
              },
            ),
            Text(getAverageScore().toString())
          ])),
    );
  }
}
