import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

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
  final List<String> LienDInscription;

  final List geolocalisation;

  Map<String, dynamic> customToJson() => {
        'titre': titre,
        'description': description,
        'image': image,
        'typeDAnimation': typeDAnimation,
        'horaireDetaile': horaireDetaile,
        'horaire': horaire,
        'nomDuLieu': nomDuLieu,
        'ville': ville,
        'descriptionLongue': descriptionLongue,
        'nombreEvenements': nombreEvenements,
        'LienDInscription': LienDInscription,
        'geolocalisation': geolocalisation,
      };

  Event({
    this.titre,
    this.description,
    this.image,
    this.typeDAnimation,
    this.horaireDetaile,
    this.nomDuLieu,
    this.ville,
    this.descriptionLongue,
    this.horaire,
    this.nombreEvenements,
    this.geolocalisation,
    this.LienDInscription,
  });

  factory Event.customFromJson(Map<String, dynamic> json) {
    return new Event(
      titre: json['titre'].toString(),
      description: json['description'].toString(),
      image: json['image'].toString(),
      typeDAnimation: json['typeDAnimation'].toString(),
      horaireDetaile: json['horaireDetaile'].toString(),
      horaire: json['horaire'].toString(),
      nomDuLieu: json['nomDuLieu'].toString(),
      ville: json['ville'].toString(),
      descriptionLongue: json['descriptionLongue'].toString(),
      nombreEvenements: json['nombreEvenements'].toString(),
      geolocalisation: json['geolocalisation'],
      LienDInscription: json['LienDInscription'].toString().split(','),
    );
  }

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
      LienDInscription:
          json['fields']['lien_d_inscription'].toString().split(','),
    );
  }
}
