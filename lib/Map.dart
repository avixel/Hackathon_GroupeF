import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'jsonHandler.dart';
import 'dart:developer';

class Map extends StatefulWidget {
  Map({Key key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Event> events;

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Set<Marker> _markers = Set();
  Marker _selMarker;
  Location _location = Location();

  double infoPos = -100;

  void setEventList() async{
    List<Event> res;
    res = (await loadEvents()).events;
    setState(() {
      events = res;
      updateMarkers();
    });
}

  void updateMarkers(){
    setState(() {
      int id = 0;
      for(Event e in events){
        _markers.add(
          Marker(
              markerId: MarkerId(id.toString()),
              position: LatLng(30+id*0.1, 30+id*0.1),
              icon: BitmapDescriptor.defaultMarker,
              onTap: (){
                _onMarkerTapped(id); // remplacer par l'id dans le for
              }
          ),
        );
        id++;
      }
    });
  }

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    setEventList();

    //_selMarker = _markers.elementAt(0);

    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 5),
        ),
      );
    });
  }

  void _onMarkerTapped(int id) {
      setState(() {
        _selMarker = _markers.elementAt(id);
        infoPos = 0;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: Stack(
        children: <Widget>[
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
            bottom: infoPos, right: 0, left: 0,
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
                      margin: EdgeInsets.only(left:15),
                      width: 70, height: 70,
                      child: ClipOval(
                        //child:
                            //Image.network(widget.events.elementAt(int.parse(_selMarker.markerId.toString())).image, fit: BoxFit.cover)
                      )
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Text(widget.events.elementAt(int.parse(_selMarker.markerId.toString())).titre),
                            Text(_selMarker.toString())
                          ],
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: IconButton(
                        icon: Icon(Icons.add_call),
                      )
                    ),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: IconButton(
                          icon: Icon(Icons.star),
                        )
                    ),
                  ],
                ),
              ),
            )
          )
        ]
      ),
    );
  }
}
