import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<bool> login(email, password) async {
  try {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    print("Login error : " + e.toString());
    return false;
  }
}

Future<bool> register(email, password) async {
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return true;
  } catch (e) {
    print("Register error : " + e.toString());
    return false;
  }
}

void signOut() async {
  await auth.signOut();
}

Stream<User> get user {
  return auth.authStateChanges();
}
