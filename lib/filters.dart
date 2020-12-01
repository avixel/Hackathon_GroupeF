import 'package:flutter/material.dart';

class Filters extends StatefulWidget {
  Filters({Key key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int where = 1;
  int what = 1;
  int when = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter tutorial"),
        ),
        body: Column(children: [
          Row(children: [
            Text("Where"),
            Container(
              padding: EdgeInsets.all(20.0),
              child: DropdownButton(
                  value: where,
                  items: [
                    DropdownMenuItem(
                      child: Text("First Item"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("Second Item"),
                      value: 2,
                    ),
                    DropdownMenuItem(child: Text("Third Item"), value: 3),
                    DropdownMenuItem(child: Text("Fourth Item"), value: 4)
                  ],
                  onChanged: (value) {
                    setState(() {
                      where = value;
                    });
                  }),
            )
          ]),
          Row(children: [
            Text("What"),
            Container(
              padding: EdgeInsets.all(20.0),
              child: DropdownButton(
                  value: what,
                  items: [
                    DropdownMenuItem(
                      child: Text("First Item"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("Second Item"),
                      value: 2,
                    ),
                    DropdownMenuItem(child: Text("Third Item"), value: 3),
                    DropdownMenuItem(child: Text("Fourth Item"), value: 4)
                  ],
                  onChanged: (value) {
                    setState(() {
                      what = value;
                    });
                  }),
            )
          ]),
          Row(children: [
            Text("When"),
            Container(
              padding: EdgeInsets.all(20.0),
              child: DropdownButton(
                  value: when,
                  items: [
                    DropdownMenuItem(
                      child: Text("First Item"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("Second Item"),
                      value: 2,
                    ),
                    DropdownMenuItem(child: Text("Third Item"), value: 3),
                    DropdownMenuItem(child: Text("Fourth Item"), value: 4)
                  ],
                  onChanged: (value) {
                    setState(() {
                      when = value;
                    });
                  }),
            )
          ])
        ]));
  }
}
