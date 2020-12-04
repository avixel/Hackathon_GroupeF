import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/DataBase.dart';
import 'Parcours.dart';
import 'Service.dart';
import 'jsonHandler.dart';

class SharedParcoursPage extends StatefulWidget {
  SharedParcoursPage({Key key}) : super(key: key);

  @override
  _SharedParcoursPageState createState() => new _SharedParcoursPageState();
}

class _SharedParcoursPageState extends State<SharedParcoursPage> {
  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shared Parcours")),
      body: ListView(children: [
        FutureBuilder<List<Pair>>(
            future: getSharedParcours(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Pair>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
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
                          Container(
                              margin: const EdgeInsets.fromLTRB(5.0, 5, 5, 5),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Parcours : " +
                                        snapshot.data[index].left.name),
                                    Text("From " + snapshot.data[index].right)
                                  ])),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  snapshot.data[index].left.events.length,
                              itemBuilder: (BuildContext c, int i) {
                                return new Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        15.0, 5, 15, 5),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blueAccent)),
                                    child: Row(children: [
                                      Expanded(
                                          child: Text(snapshot.data[index].left
                                              .events[i].titre))
                                    ]));
                              })
                        ]);
                      });
              }
            }),
      ]),
    );
  }
}
