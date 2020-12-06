import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/Services/database.dart';
import 'event_screen.dart';

class SharedParcoursScreen extends StatefulWidget {
  SharedParcoursScreen({Key key}) : super(key: key);

  @override
  _SharedParcoursScreenState createState() => new _SharedParcoursScreenState();
}

class _SharedParcoursScreenState extends State<SharedParcoursScreen> {
  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parcours partagés")),
      body:
          ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        FutureBuilder<List<Pair>>(
            future: getSharedParcours(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Pair>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError)
                  return Center(child: CircularProgressIndicator());
                else
                  return Container(
                      height: 600.0,
                      child: Scrollbar(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              padding: const EdgeInsets.all(8),
                              itemBuilder: (BuildContext context, int index) {
                                return new Column(children: [
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          5.0, 5, 5, 5),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "Parcours : " +
                                                    snapshot
                                                        .data[index].left.name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "De " +
                                                    snapshot.data[index].right,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ])),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot
                                          .data[index].left.events.length,
                                      itemBuilder: (BuildContext c, int i) {
                                        return new Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                25, 5, 25, 5),
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Row(children: [
                                              Expanded(
                                                  child: Text(snapshot
                                                      .data[index]
                                                      .left
                                                      .events[i]
                                                      .titre)),
                                              IconButton(
                                                icon: Icon(Icons.arrow_forward),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EventScreen(
                                                              event: snapshot
                                                                  .data[index]
                                                                  .left
                                                                  .events[i]),
                                                    ),
                                                  );
                                                },
                                              )
                                            ]));
                                      })
                                ]);
                              })));
              }
            }),
      ]),
    );
  }
}
