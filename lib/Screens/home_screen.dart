import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/Screens/map_screen.dart';

import 'events_screen.dart';
import 'parcours_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}




class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Êtes vous sûrs'),
        content: new Text('Voulez-vous fermer l\'applicaiton ?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NON"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("OUI"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              for (final tabItem in TabNavigationItem.items) tabItem.page,
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) => setState(() => _currentIndex = index),
            items: [
              for (final tabItem in TabNavigationItem.items)
                BottomNavigationBarItem(
                  icon: tabItem.icon,
                  label: tabItem.title,
                )
            ],
          ),
        ));
  }
}

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
            page: EventsScreen(), icon: Icon(Icons.event), title: "Évènements"),
        TabNavigationItem(
          page: MapScreen(),
          icon: Icon(Icons.map),
          title: "Carte",
        ),
        TabNavigationItem(
          page: ParcoursScreen(),
          icon: Icon(Icons.alt_route),
          title: "Parcours",
        ),
      ];
}
