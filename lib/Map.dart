import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_groupe_f/EventPage.dart';
import 'package:location/location.dart';
import 'jsonHandler.dart';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

class Map extends StatefulWidget {
  Map({Key key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Event> events;

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();

  Set<Marker> _markers = Set();
  Marker _selMarker;

  double infoPos = -100;

  void setEventList() async {
    List<Event> res;
    res = (await loadEvents()).events;
    setState(() {
      events = res;
      updateMarkers();
    });
  }

  void updateMarkers() {
    setState(() {
      int id = 0;
      for (Event e in events) {
        //log((e.geolocalisation.elementAt(0) as double).toString());
        try {
          int tid = id;
          _markers.add(
            Marker(
                markerId: MarkerId(id.toString()),
                position: LatLng((e.geolocalisation[0] as double) + 0.0,
                    (e.geolocalisation[1] as double) + 0.0),
                icon: BitmapDescriptor.defaultMarker,
                onTap: () {
                  _onMarkerTapped(tid); // remplacer par l'id dans le for
                }),
          );
          id++;
        } catch (NoSuchMethodError) {}
      }
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    _controller = _cntlr;
    setEventList();

    LocationData loc = (await _location.getLocation());
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(loc.latitude, loc.longitude), zoom: 10),
      ),
    );
  }

  void _onMarkerTapped(int id) {
    setState(() {
      _selMarker = _markers.elementAt(id);
      infoPos = 0;
    });
  }

  Event getEventById() {
    if (_selMarker == null) {
      return Event(
          titre: "",
          description: "",
          image: "",
          typeDAnimation: "",
          horaireDetaile: "",
          nomDuLieu: "",
          ville: "",
          descriptionLongue: "",
          horaire: "",
          nombreEvenements: "",
          geolocalisation: []);
    } else
      return events.elementAt(int.parse(_selMarker.markerId.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _initialcameraposition),
          mapType: MapType.normal,
          markers: _markers,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          onTap: (LatLng latLng) {
            setState(() {
              _selMarker = null;
              infoPos = -100;
            });
          },
        ),
        AnimatedPositioned(
            bottom: infoPos,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 400),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(10),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 15),
                        width: 70,
                        height: 70,
                        child: ClipOval(
                          child: getEventById().image != null
                              ? Image.network(getEventById().image,
                                  fit: BoxFit.cover)
                              : Text(""),
                        )),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(getEventById().titre),
                        ],
                      ),
                    )),
                    getEventById().LienDInscription != null &&
                            getEventById().LienDInscription.first != 'null' &&
                            getEventById()
                                .LienDInscription
                                .first
                                .contains(RegExp(r'[0-9]'))
                        ? Padding(
                            padding: EdgeInsets.all(15),
                            child: IconButton(
                              onPressed: () async {
                                String tel = 'tel:' +
                                    getEventById().LienDInscription.first;
                                if (await canLaunch(tel)) {
                                  await launch(tel);
                                } else {
                                  throw 'Could not call $tel';
                                }
                              },
                              icon: Icon(Icons.call),
                            ))
                        : Padding(padding: EdgeInsets.all(15)),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: IconButton(
                          icon: Icon(Icons.star),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Eventpage(event: getEventById()),
                              ),
                            );
                          },
                        )),
                  ],
                ),
              ),
            ))
      ]),
    );
  }
}
