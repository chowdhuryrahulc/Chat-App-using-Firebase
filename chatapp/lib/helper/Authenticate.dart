//? UNDERSTOOD
//! 1st page accessed from main.dart. Sends to SignIn or SignUp screen
//Implimented bcoz if we use pushReplacement, many SignIn & SignUp will be stacked one above the other

// ignore_for_file: file_names

import 'package:chatapp/views/signIn.dart';
import 'package:chatapp/views/signUp.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    //! This function is accessed from SignUp(SignInNow) and SignIn(RegisterNow) screen
    //! SignInNow goes to SignInPage
    //! RegisterNow goes to SignUpPage
    //! Accessed via Constructors
    //! Initially ShowSignIn is true, so user is send to SignInScreen

    //if true, then it returns false.
    //if false, then returns true.
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}
