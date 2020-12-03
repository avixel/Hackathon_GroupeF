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
        FutureBuilder<List<Parcours>>(
            future: getSharedParcours(),
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
                          ]),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data[index].events.length,
                              itemBuilder: (BuildContext c, int i) {
                                return new Text(
                                    snapshot.data[index].events[i].titre);
                              })
                        ]);
                      });
              }
            }),
      
      ]),
    );
  }
}
