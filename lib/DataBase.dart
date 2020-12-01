import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

final CollectionReference ratings = db.collection('Ratings');

Stream<QuerySnapshot> getRatings() {
  return ratings.snapshots();
}

Future<void> addRating(user, score, event) {
  return ratings
      .add({'user': user, 'score': score, "event": event})
      .then((value) => print("rating uploaded"))
      .catchError((error) => print("Error while uploading " + error));
}

double getAverageScore() {
  double counter = 0;
  getRatings()
      .listen((data) => data.docs.forEach((doc) => counter += (doc["score"])));
  return counter;
}
