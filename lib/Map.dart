import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Set<Marker> _markers = Set();
  Marker _selMarker;
  Location _location = Location();

  double infoPos = -100;

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId("0"),
            position: LatLng(45.7881142, 3.1002749),
            icon: BitmapDescriptor.defaultMarker,
            onTap: (){
              _onMarkerTapped(0); // remplacer par l'id dans le for
            }
        ),
      );
    });

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
                  color: Colors.white70,
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
                        child:
                          Image.network("https://cibul.s3.amazonaws.com/c296a0c7cf5e4d8496a3e875595a404b.base.image.jpg", fit: BoxFit.cover)
                      )
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Marker"),
                            //Text(_selMarker.toString())
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
