// ignore_for_file: prefer_const_constructors
//TODO UNDERSTOOD: search.dart, conversationscreen.dart, main.dart

//! Error:- async await in initstate is the reason we see Authenticate() for 2 sec.

import 'package:chatapp/helper/Authenticate.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/views/signIn.dart';
import 'package:chatapp/views/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //for cloud firestore, use multidex in app gradle
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;
  @override
  void initState() {
    // Using SharedPreferences to check if user is already loggedIn
    getLoggedInState();
    super.initState();
  }

//TODO... Removed async await
  getLoggedInState() {
    Helperfunctions.getuserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff145C9E),
        scaffoldBackgroundColor: (Colors.black87),
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn!
              ? ChatRoom() //!AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
              : Authenticate()
          : Container(
              child: Center(
                child: Authenticate(),
              ),
            ),
      // userIsLoggedIn! ? ChatRoom() : Authenticate(),
    );
  }
}
