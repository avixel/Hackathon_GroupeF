import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

final CollectionReference ratings = db.collection('Ratings');

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
