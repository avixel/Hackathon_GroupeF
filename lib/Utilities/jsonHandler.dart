import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:hackathon_groupe_f/Models/Event.dart';

EventsList eventsListt;

Future<String> _loadEventsAsset() async {
  return await rootBundle.loadString('assets/data.json');
}

Future<EventsList> loadEvents() async {
  if (eventsListt != null) {
    return eventsListt;
  }
  String jsonEvents = await _loadEventsAsset();
  final jsonResponse = json.decode(jsonEvents);
  EventsList eventsList = EventsList.fromJson(jsonResponse);
  eventsListt = eventsList;
  return eventsList;
}

EventsList getEventsList() {
  return eventsListt;
}

class EventsList {
  final List<Event> events;

  EventsList({
    this.events,
  });

  factory EventsList.fromJson(List<dynamic> parsedJson) {
    List<Event> events = new List<Event>();
    events = parsedJson.map((i) => Event.fromJson(i)).toList();
    return new EventsList(
      events: events,
    );
  }
}
