import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/Models/Event.dart';
import 'package:hackathon_groupe_f/Services/database.dart';
import 'parcours_screen.dart';
import '../Services/service.dart';
import '../Utilities/constants.dart';
import 'package:share/share.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  EventScreen({Key key, @required this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TextEditingController _c = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Évènement"), actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParcoursScreen(event: widget.event),
                  ),
                );
              },
              child: Icon(
                Icons.alt_route,
                size: 26.0,
              ),
            )),
      ]),
      body: ListView(
        children: [
          SizedBox(height: 10),
          Center(
              child: Text(widget.event.titre,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0, bottom: 8),
                    child: widget.event.typeDAnimation != null
                        ? Text(
                            widget.event.typeDAnimation,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : SizedBox.shrink(),
                  ),
                  widget.event.horaire != null
                      ? Text(
                          widget.event.horaire,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : SizedBox.shrink(),
                ],
              )),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Nombre d'évènements",
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
                        child: ((widget.event.image.isNotEmpty) &&
                                (widget.event.image != "null"))
                            ? Image.network(widget.event.image,
                                fit: BoxFit.cover)
                            : Text(""))
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
          widget.event.lienDInscription != null
              ? Container(
                  child: widget.event.lienDInscription.first != 'null'
                      ? Container(
                          child: Column(
                            children: [
                              Text(
                                'Inscription',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //telephone/email/website
                                    if (widget.event.lienDInscription.first
                                        .contains(RegExp(r'[0-9]')))
                                      RaisedButton(
                                        onPressed: () async {
                                          String tel = 'tel:' +
                                              widget
                                                  .event.lienDInscription.first;
                                          if (await canLaunch(tel)) {
                                            await launch(tel);
                                          } else {
                                            throw 'Could not call $tel';
                                          }
                                        },
                                        child: Icon(Icons.call),
                                      )
                                    else if (widget.event.lienDInscription.first
                                        .contains('@'))
                                      RaisedButton(
                                        onPressed: () async {
                                          String email = 'mailto:' +
                                              widget.event.lienDInscription
                                                  .first +
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
                                          String website = 'http:' +
                                              widget
                                                  .event.lienDInscription.first
                                                  .substring(7);
                                          if (await canLaunch(website)) {
                                            await launch(website);
                                          } else {
                                            throw 'Could not visit $website';
                                          }
                                        },
                                        child: Text('Website'),
                                      ),

                                    //telephone/email/website
                                    widget.event.lienDInscription.length > 1
                                        ? Container(
                                            child: widget.event.lienDInscription[
                                                            1] !=
                                                        null &&
                                                    widget.event.lienDInscription[
                                                            1] !=
                                                        'null'
                                                ? Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (widget.event
                                                            .lienDInscription[1]
                                                            .contains(RegExp(
                                                                r'[0-9]')))
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              String tel = 'tel:' +
                                                                  widget.event
                                                                      .lienDInscription[1];
                                                              if (await canLaunch(
                                                                  tel)) {
                                                                await launch(
                                                                    tel);
                                                              } else {
                                                                throw 'Could not call $tel';
                                                              }
                                                            },
                                                            child: Icon(
                                                                Icons.call),
                                                          )
                                                        else if (widget.event
                                                            .lienDInscription[1]
                                                            .contains('@'))
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              String email = 'mailto:' +
                                                                  widget.event
                                                                      .lienDInscription[1] +
                                                                  '?subject=Event inscription&body=';
                                                              if (await canLaunch(
                                                                  email)) {
                                                                await launch(
                                                                    email);
                                                              } else {
                                                                throw 'Could not email $email';
                                                              }
                                                            },
                                                            child: Icon(
                                                                Icons.email),
                                                          )
                                                        else
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              String website = 'http:' +
                                                                  widget
                                                                      .event
                                                                      .lienDInscription[
                                                                          1]
                                                                      .substring(
                                                                          7);
                                                              if (await canLaunch(
                                                                  website)) {
                                                                await launch(
                                                                    website);
                                                              } else {
                                                                throw 'Could not visit $website';
                                                              }
                                                            },
                                                            child:
                                                                Text('Website'),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                          )
                                        : SizedBox.shrink(),

                                    //telephone/email/website
                                    widget.event.lienDInscription.length > 2
                                        ? Container(
                                            child: widget.event.lienDInscription[
                                                            2] !=
                                                        null &&
                                                    widget.event.lienDInscription[
                                                            2] !=
                                                        'null'
                                                ? Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (widget.event
                                                            .lienDInscription[2]
                                                            .contains(RegExp(
                                                                r'[0-9]')))
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              String tel = 'tel:' +
                                                                  widget.event
                                                                      .lienDInscription[2];
                                                              if (await canLaunch(
                                                                  tel)) {
                                                                await launch(
                                                                    tel);
                                                              } else {
                                                                throw 'Could not call $tel';
                                                              }
                                                            },
                                                            child: Icon(
                                                                Icons.call),
                                                          )
                                                        else if (widget.event
                                                            .lienDInscription[2]
                                                            .contains('@'))
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              String email = 'mailto:' +
                                                                  widget.event
                                                                      .lienDInscription[2] +
                                                                  '?subject=Event inscription&body=';
                                                              if (await canLaunch(
                                                                  email)) {
                                                                await launch(
                                                                    email);
                                                              } else {
                                                                throw 'Could not email $email';
                                                              }
                                                            },
                                                            child: Icon(
                                                                Icons.email),
                                                          )
                                                        else
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              String website = 'http:' +
                                                                  widget
                                                                      .event
                                                                      .lienDInscription[
                                                                          2]
                                                                      .substring(
                                                                          7);
                                                              if (await canLaunch(
                                                                  website)) {
                                                                await launch(
                                                                    website);
                                                              } else {
                                                                throw 'Could not visit $website';
                                                              }
                                                            },
                                                            child:
                                                                Text('Website'),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                )
              : SizedBox.shrink(),
          Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text("Partager : "),
                IconButton(
                  icon: Icon(Icons.screen_share),
                  onPressed: () {
                    Share.share('Je suis intéressé par l\'évènement : ' +
                        widget.event.titre +
                        " !\n" +
                        widget.event.lienDInscription.toString());
                  },
                ),
                Text("Votre avis :"),
                FutureBuilder<double>(
                    future:
                        getRating(auth.currentUser.email, widget.event.titre),
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.hasError)
                          return Center(
                              child:
                                  Center(child: CircularProgressIndicator()));
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
                            onRated: (value) async {
                              await addRating(auth.currentUser.email, value,
                                  widget.event.titre);
                              setState(() {});
                            },
                          );
                      }
                    }),
                Text("Avis moyen :"),
                FutureBuilder<double>(
                  future: getAverageScore(widget.event.titre),
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError)
                        return Center(child: CircularProgressIndicator());
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
                Text("Taux de remplissage : "),
                FutureBuilder<double>(
                  future: getRemplissage(widget.event.titre),
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError)
                        return Center(child: CircularProgressIndicator());
                      else
                        return SmoothStarRating(
                          rating: snapshot.data,
                          isReadOnly: true,
                          size: 50,
                          filledIconData: Icons.person,
                          halfFilledIconData: Icons.person_outline,
                          defaultIconData: Icons.person_outline,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                        );
                    }
                  },
                ),
                orga(widget.event)
              ],
            ),
          ),
          Text("Commentaires : "),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              onSubmitted: (str) async {
                await addComments(auth.currentUser.email, widget.event, _c.text)
                    .then(
                  (value) {
                    _c.clear();
                    setState(() {});
                  },
                );
              },
              controller: _c,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                hintText: 'Commentaire',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
          Container(
            height: 300,
            child: FutureBuilder<List<Pair>>(
              future: getComments(widget.event.titre),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  Center(child: CircularProgressIndicator());

                if (snapshot.hasData) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.grey),
                                )),
                                child: Row(children: [
                                  Column(children: [
                                    Container(
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                snapshot.data[index].left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)))),
                                    Icon(Icons.person),
                                  ]),
                                  Container(
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 5, 5, 5),
                                              child: Text(
                                                  snapshot.data[index].right))))
                                ])
                                //child: Text(snapshot.data[index].left + snapshot.data[index].right,style: TextStyle(color: Colors.red),)

                                );
                          }));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  final controller = TextEditingController();
  final controllerRemplissage = TextEditingController();

  FutureBuilder<bool> orga(Event event) {
    return FutureBuilder<bool>(
        future: isOrganistaeur(widget.event.titre, auth.currentUser.email),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError)
              return Center(child: CircularProgressIndicator());
            else
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (snapshot.data)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyle,
                            height: 60.0,
                            child: TextField(
                              onSubmitted: (str) {
                                addRemplissage(
                                        controllerRemplissage.text, event.titre)
                                    .then((value) {
                                  controllerRemplissage.clear();
                                  setState(() {});
                                });
                              },
                              controller: controllerRemplissage,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                hintText: 'Taux de remplissage',
                                hintStyle: kHintTextStyle,
                              ),
                            ),
                          ),
                        ])
                ],
              );
          }
        });
  }
}
