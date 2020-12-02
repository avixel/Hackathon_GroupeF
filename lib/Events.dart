import 'package:flutter/material.dart';
import 'Parcours.dart';
import 'jsonHandler.dart';
import 'EventPage.dart';
import 'Map.dart';

class Events extends StatefulWidget {
  Events({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EventsState createState() => new _EventsState();
}

class _EventsState extends State<Events> {
  TextEditingController editingController = TextEditingController();

  String searchValueWhere = "";
  String searchValueWhat = "";
  String searchValueWhen = "";

  var showWhere = false;
  var showWhen = false;
  var showWhat = false;

  var showSearch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Events"), actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Map(),
                    ),
                  );
                },
                child: Icon(
                  Icons.map,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParcoursPage(),
                    ),
                  );
                },
                child: Icon(
                  Icons.add_location_sharp,
                  size: 26.0,
                ),
              )),
        ]),
        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              if (showSearch || true)
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: Row(children: [
                          Icon(Icons.search),
                          TextButton(
                              child: Text("Where"),
                              onPressed: () {
                                showSearch = false;
                                showWhere = true;
                                setState(() {});
                              })
                        ])),
                    Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: Row(children: [
                          Icon(Icons.search),
                          TextButton(
                              child: Text("What"),
                              onPressed: () {
                                showSearch = false;
                                showWhat = true;
                                setState(() {});
                              })
                        ])),
                    Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: Row(children: [
                          Icon(Icons.search),
                          TextButton(
                              child: Text("When"),
                              onPressed: () {
                                showSearch = false;
                                showWhen = true;
                                setState(() {});
                              })
                        ]))
                  ],
                ),
              Container(
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                    Container(
                      height: 500.0,
                      child: FutureBuilder<EventsList>(
                        future: loadEvents(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);

                          if (snapshot.hasData) {
                            if (snapshot.data == null) {
                              return Center(child: CircularProgressIndicator());
                            }
                            var list = snapshot.data.events
                                .where((element) =>
                                    element.titre.contains(searchValueWhat))
                                .toList();
                            return ListView.builder(
                                itemCount: list.length,
                                padding: const EdgeInsets.all(8),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 100,
                                    child: buildCard(
                                        context, list.elementAt(index)),
                                  );
                                });
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    )
                  ]))
            ]));
  }
}

Card buildCard(context, Event event) {
  return Card(
    child: ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 64,
          maxHeight: 64,
        ),
        child: event.image != null
            ? Image.network(event.image, fit: BoxFit.cover)
            : Text(""),
      ),
      title: event.titre != null
          ? Row(children: [
              Flexible(
                  child: RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: TextStyle(color: Colors.black), text: event.titre),
              ))
            ])
          : Text(''),
      subtitle: event.description != null
          ? Row(children: [
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      text: event.description),
                ),
              )
            ])
          : Text(""),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Eventpage(event: event),
          ),
        );
      },
    ),
  );
}
