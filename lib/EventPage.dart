import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/DataBase.dart';
import 'Service.dart';
import 'constants.dart';
import 'jsonHandler.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

class Eventpage extends StatefulWidget {
  final Event event;

  Eventpage({Key key, @required this.event}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<Eventpage> {
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
                    padding: const EdgeInsets.only(left: 0, top: 0, bottom: 8),
                    child: widget.event.typeDAnimation != null
                        ? Text(
                            widget.event.typeDAnimation,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : SizedBox.shrink(),
                  ),
                  widget.event.horaire != null
                      ? Text(
                          widget.event.horaire,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Nombre d'evenements",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    widget.event.nombreEvenements != null
                        ? Text(
                            widget.event.nombreEvenements,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                                color: Colors.green),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.event.image != null
                ? Row(children: [
                    Expanded(
                        child: Image.network(widget.event.image,
                            fit: BoxFit.contain))
                  ])
                : SizedBox.shrink(),
          ),
          widget.event.descriptionLongue != null &&
                  widget.event.descriptionLongue != 'null'
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Description',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.event.descriptionLongue),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          widget.event.horaireDetaile != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Horaires',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.event.horaireDetaile),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          widget.event.LienDInscription != null &&
                  widget.event.LienDInscription.first != 'null'
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Inscription',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.event.LienDInscription.first
                              .contains(RegExp(r'[0-9]')))
                            RaisedButton(
                              onPressed: () async {
                                String tel = 'tel:' +
                                    widget.event.LienDInscription.first;
                                if (await canLaunch(tel)) {
                                  await launch(tel);
                                } else {
                                  throw 'Could not call $tel';
                                }
                              },
                              child: Icon(Icons.call),
                            )
                          else if (widget.event.LienDInscription.first
                              .contains('@'))
                            RaisedButton(
                              onPressed: () async {
                                String email = 'mailto:' +
                                    widget.event.LienDInscription.first +
                                    '?subject=Event inscription&body=';
                                if (await canLaunch(email)) {
                                  await launch(email);
                                } else {
                                  throw 'Could not email $email';
                                }
                              },
                              child: Icon(Icons.email),
                            )
                          else
                            RaisedButton(
                              onPressed: () async {
                                String website =
                                    widget.event.LienDInscription.first;
                                if (await canLaunch(website)) {
                                  await launch(website);
                                } else {
                                  throw 'Could not visite $website';
                                }
                              },
                              child: Text('Website'),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
          widget.event.LienDInscription != null
              ? Container(
                  child: widget.event.LienDInscription.length > 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.event.LienDInscription[1] != null &&
                                  widget.event.LienDInscription[1] != 'null'
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (widget.event.LienDInscription[1]
                                          .contains(RegExp(r'[0-9]')))
                                        RaisedButton(
                                          onPressed: () async {
                                            String tel = 'tel:' +
                                                widget
                                                    .event.LienDInscription[1];
                                            if (await canLaunch(tel)) {
                                              await launch(tel);
                                            } else {
                                              throw 'Could not call $tel';
                                            }
                                          },
                                          child: Icon(Icons.call),
                                        )
                                      else if (widget.event.LienDInscription[1]
                                          .contains('@'))
                                        RaisedButton(
                                          onPressed: () async {
                                            String email = 'mailto:' +
                                                widget
                                                    .event.LienDInscription[1] +
                                                '?subject=Event inscription&body=';
                                            if (await canLaunch(email)) {
                                              await launch(email);
                                            } else {
                                              throw 'Could not email $email';
                                            }
                                          },
                                          child: Icon(Icons.email),
                                        )
                                      else
                                        RaisedButton(
                                          onPressed: () async {
                                            String website = widget
                                                .event.LienDInscription[1];
                                            if (await canLaunch(website)) {
                                              await launch(website);
                                            } else {
                                              throw 'Could not visite $website';
                                            }
                                          },
                                          child: Text('Website'),
                                        ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        )
                      : SizedBox.shrink(),
                )
              : SizedBox.shrink(),
          widget.event.LienDInscription != null
              ? Container(
                  child: widget.event.LienDInscription.length > 2
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.event.LienDInscription[2] != null &&
                                  widget.event.LienDInscription[2] != 'null'
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (widget.event.LienDInscription[2]
                                          .contains(RegExp(r'[0-9]')))
                                        RaisedButton(
                                          onPressed: () async {
                                            String tel = 'tel:' +
                                                widget
                                                    .event.LienDInscription[1];
                                            if (await canLaunch(tel)) {
                                              await launch(tel);
                                            } else {
                                              throw 'Could not call $tel';
                                            }
                                          },
                                          child: Icon(Icons.call),
                                        )
                                      else if (widget.event.LienDInscription[2]
                                          .contains('@'))
                                        RaisedButton(
                                          onPressed: () async {
                                            String email = 'mailto:' +
                                                widget
                                                    .event.LienDInscription[2] +
                                                '?subject=Event inscription&body=';
                                            if (await canLaunch(email)) {
                                              await launch(email);
                                            } else {
                                              throw 'Could not email $email';
                                            }
                                          },
                                          child: Icon(Icons.email),
                                        )
                                      else
                                        RaisedButton(
                                          onPressed: () async {
                                            String website = widget
                                                .event.LienDInscription[2];
                                            if (await canLaunch(website)) {
                                              await launch(website);
                                            } else {
                                              throw 'Could not visite $website';
                                            }
                                          },
                                          child: Text('Website'),
                                        ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        )
                      : SizedBox.shrink(),
                )
              : SizedBox.shrink(),
          Center(
            child: Column(
              children: [
                Text("Your rating"),
                FutureBuilder<double>(
                    future:
                        getRating(auth.currentUser.email, widget.event.titre),
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text("loading"));
                      } else {
                        if (snapshot.hasError)
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        else
                          return SmoothStarRating(
                            rating: snapshot.data,
                            isReadOnly: false,
                            size: 50,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: true,
                            spacing: 2.0,
                            onRated: (value) {
                              addRating(auth.currentUser.email, value,
                                  widget.event.titre);
                              setState(() {});
                            },
                          );
                      }
                    }),
                Text("Average"),
                FutureBuilder<double>(
                  future: getAverageScore(widget.event.titre),
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("loading"));
                    } else {
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else
                        return SmoothStarRating(
                          rating: snapshot.data,
                          isReadOnly: true,
                          size: 50,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                        );
                    }
                  },
                ),
                FutureBuilder<double>(
                  future: getRemplissage(widget.event.titre),
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("loading"));
                    } else {
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else
                        return Text(
                            "Remplissage : " + snapshot.data.toString());
                    }
                  },
                ),
                orga(widget.event)
              ],
            ),
          ),
        ],
      ),
    );
  }

  final controller = TextEditingController();
  final controllerRemplissage = TextEditingController();

  bool displayRemplissageEditor = false;

  Widget orga(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!displayRemplissageEditor)
          Text(
            'Password',
            style: kLabelStyle,
          ),
        if (!displayRemplissageEditor) SizedBox(height: 10.0),
        if (!displayRemplissageEditor)
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: controller,
              obscureText: true,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Enter your orga Password',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        if (!displayRemplissageEditor)
          TextButton(
            child: Text("GO"),
            onPressed: () {
              orgaMDP(event.titre, controllerRemplissage.text).then((value) {
                if (value) {
                  displayRemplissageEditor = true;
                  setState(() {});
                }
              });
            },
          ),
        if (displayRemplissageEditor)
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Remplissage',
                  style: kLabelStyle,
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  height: 60.0,
                  child: TextField(
                    controller: controllerRemplissage,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      hintText: 'Remplissage',
                      hintStyle: kHintTextStyle,
                    ),
                  ),
                ),
                TextButton(
                    child: Text("GO"),
                    onPressed: () {
                      addRemplissage(controllerRemplissage.text, event.titre)
                          .then((value) {
                        setState(() {});
                      });
                    }),
              ])
      ],
    );
  }
}
