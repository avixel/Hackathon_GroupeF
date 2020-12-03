import 'package:cloud_firestore/cloud_firestore.dart';

import 'Parcours.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

final CollectionReference ratings = db.collection('Ratings');
final CollectionReference orgas = db.collection('OrganisateurEvent');
final CollectionReference remplissage = db.collection('Remplissage');
final CollectionReference parcours = db.collection('Parcours');

Stream<QuerySnapshot> getRatings() {
  return ratings.snapshots();
}

Future<double> getRating(user, event) async {
  var usersRef = ratings.doc(user + "-" + event.substring(0,10));

  double res = 0;

  await usersRef.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = docSnapshot.get("score");
    }
  });
  return res;
}

Future<void> addRating(user, score, event) async {
  var usersRef = ratings.doc(user + "-" + event.substring(0,10));

  await usersRef.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      usersRef.update({'score': score});
    } else {
      return usersRef
          .set({'user': user, 'score': score, "event": event.substring(0,10)})
          .then((value) => print("rating uploaded"))
          .catchError((error) => print("Error while uploading " + error));
    }
  });
}

Future<double> getAverageScore(event) async {
  double total = 0;
  double count = 0;
  await ratings.get().then((value) => value.docs.forEach((element) {
        if (element.data()["event"] == event.substring(0,10)) {
          total += element.data()["score"];
          count = count + 1;
        }
      }));
  if (count == 0) {
    return 0;
  }
  return (total / count);
}


Future<double> getRemplissage(String event) async {
  var temp = remplissage.doc(event.substring(0,10));

  double res = 0;

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = double.parse(docSnapshot.get("remplissage"));
    }
  });
  return res;
}

Future<bool> addRemplissage(remp, event) async {
  var temp = remplissage.doc(event.substring(0,10));

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


Future<double> getParcours(String user) async {
  var temp = parcours.doc(user);

  double res = 0;

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = double.parse(docSnapshot.get("remplissage"));
    }
  });
  return res;
}

Future<bool> addParcours(user,Parcours parc) async {
  var temp = parcours.doc(user+"-"+parc.name);

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      return temp.update({'parcours': parc.toJson()});
    } else {
      return temp
          .set({'parcours': parc.toJson()})
          .then((value) => print("parcours uploaded"))
          .catchError((error) => print("Error while uploading " + error.toString()));
    }
  });
  return true;
}



Future<bool> isOrganistaeur(event, user) async {
  var temp = orgas.doc(event.substring(0,10));

  bool res = false;

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = (docSnapshot.get("orgas").contains(user));
    }
  });
  return res;
}