// ignore_for_file: prefer_const_constructors
//TODO UNDERSTOOD: search.dart, conversationscreen.dart, main.dart

import 'package:chatapp/TikTakToe/providers.dart';
import 'package:chatapp/helper/Authenticate.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/views/signIn.dart';
import 'package:chatapp/views/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //for cloud firestore, use multidex in app gradle
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getLoggedInState();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=> recieverNameProvider())
    ],
    child: const MyApp()));
}

bool? userIsLoggedIn;

getLoggedInState() {
  Helperfunctions.getuserLoggedInSharedPreference().then((value) {
    userIsLoggedIn = value;
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
              ? ChatRoom()
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
