import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

final CollectionReference ratings = db.collection('Ratings');
final CollectionReference orgas = db.collection('OrganisateurEvent');
final CollectionReference remplissage = db.collection('Remplissage');

Stream<QuerySnapshot> getRatings() {
  return ratings.snapshots();
}

Future<double> getRating(user, event) async {
  var usersRef = ratings.doc(user + "-" + event);

  double res = 0;

  await usersRef.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = docSnapshot.get("score");
    }
  });
  return res;
}

Future<void> addRating(user, score, event) {
  var usersRef = ratings.doc(user + "-" + event);

  usersRef.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      usersRef.update({'score': score});
    } else {
      return usersRef
          .set({'user': user, 'score': score, "event": event})
          .then((value) => print("rating uploaded"))
          .catchError((error) => print("Error while uploading " + error));
    }
  });
}

Future<double> getAverageScore(event) async {
  double total = 0;
  double count = 0;
  await ratings.get().then((value) => value.docs.forEach((element) {
        if (element.data()["event"] == event) {
          total += element.data()["score"];
          count = count + 1;
        }
      }));
  if (count == 0) {
    return 0;
  }
  return (total / count);
}

Future<bool> orgaMDP(event, mdp) async {
  var temp = orgas.doc(event);

  bool res = false;

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = (docSnapshot.get("mdp") == mdp);
    }
  });
  return res;
}

Future<double> getRemplissage(event) async {
  var temp = remplissage.doc(event);

  double res = 0;

  await temp.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      res = double.parse(docSnapshot.get("remplissage"));
    }
  });
  return res;
}

Future<bool> addRemplissage(remp, event) async {
  var temp = remplissage.doc(event);

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
