import 'package:flutter/material.dart';

import 'jsonHandler.dart';

class ParcoursPage extends StatefulWidget {
  final Event event;

  ParcoursPage({Key key, @required this.event}) : super(key: key);

  @override
  _ParcoursPageState createState() => new _ParcoursPageState();
}

class _ParcoursPageState extends State<ParcoursPage> {
  TextEditingController _c;
  List<Parcours> parcoursList = [];

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
        ListView.builder(
            shrinkWrap: true,
            itemCount: parcoursList.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return new Column(children: [
                Row(children: [
                  Text(parcoursList[Index].name),
                  if (widget.event != null)
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: Text("ADD"),
                      onPressed: () {
                        parcoursList[Index].events.add(widget.event);
                        setState(() {});
                      },
                    ),
                ]),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: parcoursList[Index].events.length,
                    itemBuilder: (BuildContext c, int i) {
                      return new Text(
                          parcoursList[Index].events[i].titre.substring(0, 50));
                    })
              ]);
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
                            onPressed: () {
                              setState(() {
                                parcoursList.add(Parcours(_c.text, []));
                              });
                              Navigator.pop(context);
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
}
