import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


Future<String> _loadEventsAsset() async {
  return await rootBundle.loadString('assets/data.json');
}

Future<EventsList> loadEvents() async {
  String jsonEvents = await _loadEventsAsset();
  final jsonResponse = json.decode(jsonEvents);
  EventsList eventsList = EventsList.fromJson(jsonResponse);
  return eventsList;
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

class Event {
  final String titre;
  final String description;
  final String image;

  final String typeDAnimation;
  final String horaireDetaile;
  final String horaire;
  final String nomDuLieu;
  final String ville;
  final String descriptionLongue;
  final String nombreEvenements;

  final List geolocalisation;


  Event({this.titre, this.description, this.image, this.typeDAnimation, this.horaireDetaile,this.nomDuLieu, this.ville,
    this.descriptionLongue, this.horaire, this .nombreEvenements, this.geolocalisation});

  factory Event.fromJson(Map<String, dynamic> json) {
    return new Event(
      titre: json['fields']['titre_fr'].toString(),
      description: json['fields']['description_fr'].toString(),
      image: json['fields']['image'].toString(),
      typeDAnimation: json['fields']['type_d_animation'].toString(),
      horaireDetaile: json['fields']['horaires_detailles_fr'].toString(),
      horaire: json['fields']['resume_horaires_fr'].toString(),
      nomDuLieu: json['fields']['nom_du_lieu'].toString(),
      ville: json['fields']['ville'].toString(),
      descriptionLongue: json['fields']['description_longue_fr'].toString(),
      nombreEvenements: json['fields']['nb_evenements'].toString(),
      geolocalisation: json['fields']['geolocalisation'],

    );
  }
}
