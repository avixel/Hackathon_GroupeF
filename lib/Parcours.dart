import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/DataBase.dart';
import 'dart:math';
import 'Service.dart';
import 'jsonHandler.dart';

class ParcoursPage extends StatefulWidget {
  final Event event;

  ParcoursPage({Key key, @required this.event}) : super(key: key);

  @override
  _ParcoursPageState createState() => new _ParcoursPageState();
}

class _ParcoursPageState extends State<ParcoursPage> {
  TextEditingController _c;

  @override
  initState() {
    super.initState();
    _c = new TextEditingController();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parcours"),
      ),
      body: ListView(children: [
        FutureBuilder<List<Parcours>>(
            future: getParcours(auth.currentUser.email),
            builder:
                (BuildContext context, AsyncSnapshot<List<Parcours>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text("loading"));
              } else {
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (BuildContext context, int index) {
                        return new Column(children: [
                          Row(children: [
                            Text(snapshot.data[index].name),
                            if (widget.event != null)
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                ),
                                child: Text("ADD"),
                                onPressed: () async {
                                  var v = snapshot.data[index].events;
                                  v.add(widget.event);
                                  await addParcours(auth.currentUser.email,
                                          Parcours(snapshot.data[index].name, v))
                                      .then((value) {});
                                  setState(() {});
                                },
                              ),
                          ]),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data[index].events.length,
                              itemBuilder: (BuildContext c, int i) {
                                return new Text(snapshot.data[index].events[i].titre);
                                //return new Text(snapshot
                                //  .data[index].events[i].titre
                                //.substring(0, min(50,snapshot.data[index].events[i].titre.length)));
                              })
                        ]);
                      });
              }
            }),
        Container(
          height: 40,
          color: Colors.deepOrange,
          child: Center(
            child: TextButton(
              child: Text("Add parcours"),
              onPressed: () {
                showDialog(
                    child: new Dialog(
                      child: new Column(
                        children: <Widget>[
                          new TextField(
                            decoration:
                                new InputDecoration(hintText: "Parcours name"),
                            controller: _c,
                          ),
                          new FlatButton(
                            child: new Text("Save"),
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
      ]),
    );
  }
}

class Parcours {
  String name;
  List<Event> events;

  Parcours(this.name, this.events);

  Map toJson() {
    List<Map> events = this.events != null
        ? this.events.map((i) => i.customToJson()).toList()
        : null;

    return {
      'name': name,
      'events': events,
    };
  }

  factory Parcours.fromJson(Map<String, dynamic> json) {
    var events = json['events'];
    List<Event> t = [];
    for (var e in events) {
      Event newE = Event.customFromJson(e);
      t.add(newE);
    }
    return new Parcours(json['name'].toString(), t);
  }
}
