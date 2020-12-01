import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Events"),
          actions: <Widget>[
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
                )
            ),
          ]
        ),
        body: Container(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {},
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Container(
            height: 500.0,
            child: FutureBuilder<EventsList>(
              future: loadEvents(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                var list = snapshot.data.events;
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: list.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 100,
                            child: buildCard(context, list[index]),
                          );
                        })
                    : Center(child: CircularProgressIndicator());
              },
            ),
          )
        ])));
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
        child: Image.network(event.image, fit: BoxFit.cover),
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
