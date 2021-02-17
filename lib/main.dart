import 'package:flutter/material.dart';
import 'WelcomeScreen/WelcomeScreen.dart';
import 'Authentication/login_screen.dart';
import 'Authentication/root_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
//WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: 'Fryes',
    home: MyHomePage(), // loginpage
//  home : WelcomeScreen()  , // direct college selet
    //  home: LandingPage(),
  ));
}
