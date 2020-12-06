import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackathon_groupe_f/Screens/event_screen.dart';
import 'package:location/location.dart';
import '../Utilities/jsonHandler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

import 'package:hackathon_groupe_f/Models/Event.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Event> events;

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();

  Set<Marker> _markers = Set();
  Marker _selMarker;
  ClusterManager _manager;
  List<ClusterItem<int>> items = List<ClusterItem<int>>();

  double infoPos = -100;

  @override
  void initState() {
    //_manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    if(items!=null) log(items.length.toString());
    return ClusterManager<int>(items, _updateMarkers,
        markerBuilder: _markerBuilder,
        initialZoom: 10,
        stopClusteringZoom: 15.0);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this._markers = markers;
    });
  }

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
          items.add(
            ClusterItem(
                LatLng((e.geolocalisation[0] as double)+0.0, (e.geolocalisation[1] as double)+0.0),
                item: tid
            ),
          );
          id++;
          //log(id.toString());
        } catch(NoSuchMethodError){log("Error adding");}
      }
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    _controller = _cntlr;

    setEventList();

    _manager = _initClusterManager();
    _manager.setMapController(_cntlr);

    LocationData loc = (await _location.getLocation());
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(loc.latitude, loc.longitude), zoom: 10),
      ),
    );
  }

  void _onCameraMove(CameraPosition _cmps) async {
    _manager.onCameraMove(_cmps);
  }

  void _onCameraIdle() async {
    _manager.updateMap();
  }

  void _onMarkerTapped(int id) {
      setState(() {
        log("tap!");
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

  Future<Marker> Function(Cluster<int>) get _markerBuilder =>
          (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.items.first.toString()),
          position: cluster.location,
          onTap: () {
            _onMarkerTapped(int.parse(cluster.items.first.toString()));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String text}) async {
    assert(size != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.red;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Map"),
          automaticallyImplyLeading: false
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _initialcameraposition),
            mapType: MapType.normal,
            markers: _markers,

            onMapCreated: _onMapCreated,
            onCameraMove:  _onCameraMove,
            onCameraIdle: _onCameraIdle,
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
                          child: ((getEventById().image != null)&&getEventById().image.isNotEmpty && getEventById().image!="null")
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
                    getEventById().lienDInscription != null &&
                            getEventById().lienDInscription.first != 'null' &&
                            getEventById()
                                .lienDInscription
                                .first
                                .contains(RegExp(r'[0-9]'))
                        ? Padding(
                            padding: EdgeInsets.all(15),
                            child: IconButton(
                              onPressed: () async {
                                String tel = 'tel:' +
                                    getEventById().lienDInscription.first;
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
                                    EventScreen(event: getEventById()),
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
