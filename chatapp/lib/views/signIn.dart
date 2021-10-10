// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/widgits/widgits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  // Accessed function from Authenticate Screen
  final Function toggle; //?UNDERSTOOD
  const SignIn(this.toggle, {Key? key}) : super(key: key);
  //! To access this downstares we use widget.toggle.
  //? Widgit.toggle is only for stateful widgit. Not stateless
  //see RegisterNow

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  Authmethords authmethords = Authmethords();
  DatabaseMethords databaseMethords = DatabaseMethords();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

  signMeIN() {
    //! 1) validate
    //! 2) Add email to Sp
    //! 3) Show loading
    //! 4) Create Query function in Database to get User by userEmail (rather than userName)
    //? (wherever xyz... = xyz..., send data)
    //! 5) From 0 docoment, we are getting name
    //! 6) save in Sp
    //! 7) Sign him In
    //! 8) If successfully signed in, send to next screen
    //! 9) Save in Sp as true

    if (formKey.currentState!.validate()) {
      Helperfunctions.saveuserEmailSharedPreference(email.text);
      // Function to get userDetails
      databaseMethords.getUserByUserEmail(email.text).then((val) {
        snapshotUserInfo = val; //? Firebase gives QuerySnapshot
        Helperfunctions.saveuserNameSharedPreference(
            snapshotUserInfo!.docs[0]["name"]);
      });
      setState(() {
        isLoading = true;
      });

      authmethords
          .signInWithEmailAndPassword(email.text, password.text)
          .then((value) {
        if (value != null) {
          Helperfunctions.saveuserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatRoom())); //!AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Enter correct email";
                            },
                            controller: email,
                            style: simpleTextFieldStyle(),
                            decoration: textFieldInputDecoration('Email')),
                        TextFormField(
                            validator: (val) {
                              return val!.length > 6
                                  ? null
                                  : "Please provide password greater than 6 characters";
                            },
                            obscureText: true,
                            controller: password,
                            style: simpleTextFieldStyle(),
                            decoration: textFieldInputDecoration('Password')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Forgot Password?',
                        style: simpleTextFieldStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ]),
                          borderRadius: BorderRadius.circular(30)),
                      child: Text('Sign In', style: mediumTextFieldStyle()),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Sign In with Google',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: mediumTextFieldStyle()),
                      GestureDetector(
                        onTap: () {
                          widget.toggle(); //? UNDERSTOOD
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register now",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  decoration: TextDecoration.underline)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
