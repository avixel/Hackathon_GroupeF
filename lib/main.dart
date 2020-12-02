import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_groupe_f/DataBase.dart';
import 'package:hackathon_groupe_f/Events.dart';
import 'jsonHandler.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    loadEvents();
    return MaterialApp(
      title: 'Hackaton',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
