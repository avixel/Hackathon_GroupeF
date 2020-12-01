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
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0,top: 0,bottom: 8),
                    child: widget.event.typeDAnimation != null ?
                    Text(widget.event.typeDAnimation, textAlign: TextAlign.start , style: TextStyle(fontWeight: FontWeight.bold),) : SizedBox.shrink(),
                  ),
                  widget.event.horaire != null ?
                  Text(widget.event.horaire, style: TextStyle(fontWeight: FontWeight.bold),) : SizedBox.shrink(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0,top: 8,bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Nombre d'evenement", style: TextStyle(fontWeight: FontWeight.bold),),
                    widget.event.nombreEvenements != null ?
                    Text(widget.event.nombreEvenements, textAlign: TextAlign.end , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: Colors.green),) : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.event.image != null ? Expanded(child: Image.network(widget.event.image, fit: BoxFit.contain)) : SizedBox.shrink(),
          ),

          widget.event.descriptionLongue != null && widget.event.descriptionLongue != 'null' ? Column(
            children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text('Description',textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold),),
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(widget.event.descriptionLongue),
               ) ,
            ],
          ) : SizedBox.shrink(),

          widget.event.horaireDetaile != null ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Horaire',textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.event.horaireDetaile),
              ) ,
            ],
          ) : SizedBox.shrink(),



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
          Text(getAverageScore().toString()),
        ],
      ),
    );
  }
}
