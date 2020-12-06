import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_groupe_f/Models/Event.dart';
import 'package:hackathon_groupe_f/Models/Parcours.dart';
import 'dart:convert';

final FirebaseFirestore db = FirebaseFirestore.instance;

final CollectionReference ratings = db.collection('Ratings');
final CollectionReference orgas = db.collection('OrganisateurEvent');
final CollectionReference remplissage = db.collection('Remplissage');
final CollectionReference parcours = db.collection('Parcours');
final CollectionReference sharedParcours = db.collection('SharedParcours');
final CollectionReference comments = db.collection('Comments');

Stream<QuerySnapshot> getRatings() {
  return ratings.snapshots();
}

Future<double> getRating(user, Event event) async {
  var usersRef = ratings.doc(user + "-" + event.identifiant);

  double res = 0;

  await usersRef.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = docSnapshot.get("score");
    }
  });
  return res;
}

Future<void> addRating(user, score, Event event) async {
  var usersRef = ratings.doc(user + "-" + event.identifiant);

  await usersRef.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      usersRef.update({'score': score});
    } else {
      return usersRef
          .set({'user': user, 'score': score, "event": event.identifiant})
          .then((value) => print("rating uploaded"))
          .catchError((error) => print("Error while uploading " + error));
    }
  });
}

Future<double> getAverageScore(Event event) async {
  double total = 0;
  double count = 0;
  await ratings.get().then((value) => value.docs.forEach((element) {
        if (element.data()["event"] == event.identifiant) {
          total += element.data()["score"];
          count = count + 1;
        }
      }));
  if (count == 0) {
    return 0;
  }
  return (total / count);
}

Future<double> getRemplissage(Event event) async {
  var temp = remplissage.doc(event.identifiant);

  double res = 0;

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = double.parse(docSnapshot.get("remplissage"));
    }
  });
  return res;
}

Future<bool> addRemplissage(remp, Event event) async {
  var temp = remplissage.doc(event.identifiant);

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      return temp.update({'remplissage': remp});
    } else {
      return temp
          .set({'remplissage': remp})
          .then((value) => print("remplissage uploaded"))
          .catchError((error) => print("Error while uploading " + error));
    }
  });
  return true;
}

Future<List<Parcours>> getParcours(String user) async {
  var temp = parcours.doc(user);

  List<Parcours> res = [];
  Map<String, dynamic> map;

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      map = docSnapshot.data();
    }
  });
  if (map != null) {
    for (var v in map.values) {
      var j = json.decode(v);
      Parcours p = Parcours.fromJson(j);
      res.add(p);
    }
  }
  return res;
}

Future<bool> addParcours(user, Parcours parc) async {
  var temp = parcours.doc(user);

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      return temp.update({parc.name: jsonEncode(parc.toJson())});
    } else {
      return temp
          .set({parc.name: jsonEncode(parc.toJson())})
          .then((value) => print("parcours uploaded"))
          .catchError(
              (error) => print("Error while uploading " + error.toString()));
    }
  });
  return true;
}

Future<bool> removeFromParcours(Event event, user, Parcours parc) async {
  var temp = parcours.doc(user);

  await temp.get().then((docSnapshot) {
    parc.remove(event);
    return temp.update({parc.name: jsonEncode(parc.toJson())});
  });
  return true;
}

Future<bool> removeParcours(user, Parcours parc) async {
  var temp = parcours.doc(user);

  await temp.get().then((docSnapshot) {
    return temp.update({parc.name: FieldValue.delete()});
  });
  return true;
}

Future<List<Pair>> getSharedParcours() async {
  List<Pair> res = [];
  Map<String, dynamic> map;

  await sharedParcours.get().then((value) => value.docs.forEach((element) {
        map = element.data();
        if (map != null) {
          for (var v in map.values) {
            var j = json.decode(v);
            Parcours p = Parcours.fromJson(j);
            Pair pair = new Pair(p, element.id);
            res.add(pair);
          }
        }
      }));
  return res;
}

Future<List<Pair>> getComments(Event event) async {
  List<Pair> res = [];
  Map<String, dynamic> map;

  print('allo');
  print(event.identifiant);
  var temp = comments.doc(event.identifiant);

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      map = docSnapshot.data();
      if (map != null) {
        for (var e in map.entries) {
          for (String s in e.value) {
            Pair pair = new Pair(e.key, s);
            res.add(pair);
          }
        }
      }
    }
  });

  return res;
}

Future<bool> addComments(String user, Event event, String com) async {
  var temp = comments.doc(event.identifiant);
  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      List<dynamic> l = docSnapshot.data()[user];

      List<String> ll = [];
      if (l != null) {
        l.forEach((element) {
          ll.add(element.toString());
        });
      }
      ll.add(com);
      return temp.set({user.toString(): ll}, SetOptions(merge: true));
    } else {
      return temp
          .set({
            user: [com]
          }, SetOptions(merge: true))
          .then((value) => print("comments uploaded"))
          .catchError(
              (error) => print("Error while uploading " + error.toString()));
    }
  });
  return true;
}

Future<bool> addSharedParcours(user, Parcours parc) async {
  var temp = sharedParcours.doc(user);
  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      return temp.update({parc.name: jsonEncode(parc.toJson())});
    } else {
      return temp
          .set({parc.name: jsonEncode(parc.toJson())})
          .then((value) => print("parcours uploaded"))
          .catchError(
              (error) => print("Error while uploading " + error.toString()));
    }
  });
  return true;
}

Future<bool> isOrganistaeur(Event event, user) async {
  var temp = orgas.doc(event.identifiant);

  bool res = false;

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = (docSnapshot.get("orgas").contains(user));
    }
  });
  return res;
}

class Pair {
  Pair(this.left, this.right);

  final dynamic left;
  final dynamic right;

  @override
  String toString() => 'Pair[$left, $right]';
}
