import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_groupe_f/Models/Parcours.dart';
import 'package:hackathon_groupe_f/Services/database.dart';
import 'package:hackathon_groupe_f/Screens/shared_parcours_screen.dart';
import 'package:pdf/pdf.dart';
import 'event_screen.dart';
import '../Services/service.dart';
import 'package:hackathon_groupe_f/Models/Event.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'package:open_file/open_file.dart';

import 'package:pdf/widgets.dart' as pw;

class ParcoursScreen extends StatefulWidget {
  final Event event;

  ParcoursScreen({Key key, @required this.event}) : super(key: key);

  @override
  _ParcoursScreenState createState() => new _ParcoursScreenState();
}

class _ParcoursScreenState extends State<ParcoursScreen> {
  TextEditingController _c;

  @override
  initState() {
    super.initState();
    _c = new TextEditingController();
  }

  Future<void> createPDF(Parcours parcours) async {
    final font = await rootBundle.load("assets/open-sans.ttf");
    final ttf = pw.Font.ttf(font);

    final doc = pw.Document();

    List<pw.Row> eventsTitles = [];

    for (Event event in parcours.events) {
      eventsTitles.add(pw.Row(children: [
        pw.Text('Évènement : ' + event.titre, style: pw.TextStyle(font: ttf))
      ]));
    }

    doc.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
            child: pw.Column(children: [
          pw.Text("Parcours : " + parcours.name,
              style: pw.TextStyle(color: PdfColors.blue, font: ttf)),
          pw.Column(
            children: eventsTitles,
          )
        ])),
      ),
    );

    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    final file = File(appDocDirectory.path + "/" + parcours.name + ".pdf");

    file.writeAsBytesSync(doc.save());

    OpenFile.open(file.path);
  }

  Future<void> handleClick(String value, Parcours parcours) async {
    switch (value) {
      case 'PDF':
        var v = parcours.events;
        createPDF(Parcours(parcours.name, v));
        setState(() {});
        break;
      case 'Partager':
        var v = parcours.events;
        await addSharedParcours(
                auth.currentUser.email, Parcours(parcours.name, v))
            .then((value) {});
        setState(() {});
        break;
      case 'Supprimer':
        await removeParcours(auth.currentUser.email, parcours);
        setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parcours"), actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SharedParcoursScreen(),
                  ),
                );
              },
              child: Icon(
                Icons.share,
                size: 26.0,
              ),
            )),
      ]),
      body: Container(
          child: ListView(children: [
        Container(
          height: 40,
          color: Colors.blueGrey,
          child: Center(
            child: TextButton(
              child: Text("Ajouter parcours",style: TextStyle(color: Colors.white),),
              onPressed: () {
                showDialog(
                    child: new Dialog(
                      shape: RoundedRectangleBorder(),
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new TextField(
                            decoration: new InputDecoration(
                                hintText: "Nom du parcours"),
                            controller: _c,
                          ),
                          new FlatButton(
                            child: new Text("Ajouter"),
                            onPressed: () async {
                              await addParcours(auth.currentUser.email,
                                  Parcours(_c.text, [])).then((value) {
                                Navigator.pop(context);
                                setState(() {});
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    context: context);
              },
            ),
          ),
        ),
        ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
          FutureBuilder<List<Parcours>>(
              future: getParcours(auth.currentUser.email),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Parcours>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError)
                    return Center(child: CircularProgressIndicator());
                  else
                    return Container(
                        height: widget.event == null ? 520.0 : 580,
                        child: Scrollbar(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                padding: const EdgeInsets.all(8),
                                itemBuilder: (BuildContext context, int index) {
                                  return new ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                            child: Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 5, 5, 5),
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "Parcours : " +
                                                              snapshot
                                                                  .data[index]
                                                                  .name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Container(
                                                          child: Row(children: [
                                                        PopupMenuButton<String>(
                                                          onSelected: (String
                                                              result) async {
                                                            await handleClick(
                                                                result,
                                                                snapshot.data[
                                                                    index]);
                                                          },
                                                          itemBuilder:
                                                              (BuildContext
                                                                  context) {
                                                            return {
                                                              'PDF',
                                                              'Partager',
                                                              "Supprimer"
                                                            }.map((String
                                                                choice) {
                                                              return PopupMenuItem<
                                                                  String>(
                                                                value: choice,
                                                                child: Text(
                                                                    choice),
                                                              );
                                                            }).toList();
                                                          },
                                                        ),
                                                      ])),
                                                    ]))),
                                        Container(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshot
                                                    .data[index].events.length,
                                                itemBuilder:
                                                    (BuildContext c, int i) {
                                                  return new Container(
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          25.0, 5, 25, 5),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .events[
                                                                            i]
                                                                        .titre)),
                                                            IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .highlight_remove_outlined,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  await removeFromParcours(
                                                                          snapshot.data[index].events[
                                                                              i],
                                                                          auth.currentUser
                                                                              .email,
                                                                          Parcours(
                                                                              snapshot.data[index].name,
                                                                              snapshot.data[index].events))
                                                                      .then((value) {});

                                                                  setState(
                                                                      () {});
                                                                }),
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  color: Colors
                                                                      .green),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => EventScreen(
                                                                        event: snapshot
                                                                            .data[index]
                                                                            .events[i]),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          ]));
                                                })),
                                        if (widget.event != null &&
                                            !snapshot.data[index]
                                                .containsEvent(widget.event))
                                          TextButton(
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () async {
                                              var v =
                                                  snapshot.data[index].events;
                                              v.add(widget.event);
                                              await addParcours(
                                                      auth.currentUser.email,
                                                      Parcours(
                                                          snapshot
                                                              .data[index].name,
                                                          v))
                                                  .then((value) {});

                                              setState(() {});
                                            },
                                          )
                                      ]);
                                })));
                }
              }),
        ])
      ])),
    );
  }
}
