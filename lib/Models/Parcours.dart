import 'package:hackathon_groupe_f/Models/Event.dart';

class Parcours {
  String name;
  List<Event> events;

  Parcours(this.name, this.events);

  bool containsEvent(event) {
    for (Event e in events) {
      if (e.titre == event.titre) {
        return true;
      }
    }
    return false;
  }

  void remove(event) {
    this.events.retainWhere((x) => x.titre != event.titre);
  }

  Map toJson() {
    final ids = this.events.map((e) => e.titre).toSet();
    this.events.retainWhere((x) => ids.remove(x.titre));

    List<Map> events = this.events != null
        ? this.events.map((i) => i.customToJson()).toList()
        : null;

    return {
      'name': name,
      'events': events,
    };
  }

  factory Parcours.fromJson(Map<String, dynamic> json) {
    var events = json['events'];
    List<Event> t = [];
    for (var e in events) {
      Event newE = Event.customFromJson(e);
      t.add(newE);
    }
    return new Parcours(json['name'].toString(), t);
  }
}
