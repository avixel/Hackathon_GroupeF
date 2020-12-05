import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/events_screen.dart';
import 'Screens/home_screen.dart';
import 'Utilities/jsonHandler.dart';
import 'Screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  loadEvents();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(MaterialApp(
      title: 'Hackaton',
      debugShowCheckedModeBanner: false,
      home: email == null ? LoginScreen() : HomeScreen()));
}
