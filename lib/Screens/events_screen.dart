import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/service.dart';
import '../Utilities/jsonHandler.dart';
import 'event_screen.dart';
import 'package:hackathon_groupe_f/Models/Event.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EventsScreenState createState() => new _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
        appBar: AppBar(title: Text("Évènements"), automaticallyImplyLeading: false,actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email');
                  auth.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => LoginScreen()));
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ]),
        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              if (!showSearch)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    onSubmitted: (String value) {
                      showSearch = true;
                      if (showWhat) {
                        searchValueWhat = editingController.text;
                      }
                      if (showWhen) {
                        searchValueWhen = editingController.text;
                      }
                      if (showWhere) {
                        searchValueWhere = editingController.text;
                      }
                      editingController.clear();
                      setState(() {});
                    },
                    onChanged: (value) {},
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Recherche",
                        hintText: "Recherche",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
              if (showSearch)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: Row(children: [
                          Icon(Icons.search),
                          TextButton(
                              child: Text("Où"),
                              onPressed: () {
                                showSearch = false;
                                showWhere = true;
                                showWhen = false;
                                showWhat = false;
                                editingController.text = searchValueWhere;
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
                              child: Text("Quoi"),
                              onPressed: () {
                                showSearch = false;
                                showWhat = true;
                                showWhere = false;
                                showWhen = false;
                                editingController.text = searchValueWhat;
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
                              child: Text("Quand"),
                              onPressed: () {
                                showSearch = false;
                                showWhen = true;
                                showWhere = false;
                                showWhat = false;
                                editingController.text = searchValueWhen;
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
                      height: 600.0,
                      child: FutureBuilder<EventsList>(
                        future: loadEvents(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            Center(child: CircularProgressIndicator());

                          if (snapshot.hasData) {
                            if (snapshot.data == null) {
                              return Center(child: CircularProgressIndicator());
                            }
                            var list = snapshot.data.events
                                .where((element) => test(element))
                                .toList();
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: list.length,
                                padding: const EdgeInsets.all(8),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 80,
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

  bool test(element) {
    var temp = (element.titre.contains(searchValueWhat) ||
            element.description.contains(searchValueWhat) ||
            element.descriptionLongue.contains(searchValueWhat)) &&
        (element.horaire.contains(searchValueWhen) ||
            element.horaireDetaile.contains(searchValueWhen)) &&
        (element.nomDuLieu.contains(searchValueWhere) ||
            element.ville.contains(searchValueWhere));

    return temp;
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
        child: ((event.image != null) &&
                event.image.isNotEmpty &&
                event.image != "null")
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
            builder: (context) => EventScreen(event: event),
          ),
        );
      },
    ),
  );
}
