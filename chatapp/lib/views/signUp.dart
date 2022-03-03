// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/widgits/widgits.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  const SignUp(this.toggle, {Key? key}) : super(key: key);
  //see signIn screen for explaination

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Authmethords authmethords = Authmethords(); //to use authMethords
  DatabaseMethords databaseMethords = DatabaseMethords();

  bool isLoading = false;
  final formKey = GlobalKey<FormState>(); //Key is used for Validation

  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signMEUP() {
    //? onTap signUP button
    if (formKey.currentState!.validate()) {
      //Map is collection of key value pair
      //Here we are defiing a map with Key=String, Value=String
      //To define List we use []. To define Map we use {}
      //adding value to Map ||Createing a Map
      Map<String, String> userInfoMap = {
        //"name" shoule be same as in Firestore
        "name": userName.text,
        "email": email.text,
      };
      // Helperfunctions.saveuserLoggedInSharedPreference(true);
      Helperfunctions.saveuserNameSharedPreference(userName.text);
      Helperfunctions.saveuserEmailSharedPreference(email.text);
      setState(() {
        isLoading = true;
      });
      authmethords
          .signUpWithEmailAndPassword(email.text, password.text)
          .then((value) {
        if (value != null) {
          databaseMethords.uploadUserInfo(userInfoMap);
          Helperfunctions.saveuserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              //So that if user press back button it doesnt redirect to this page
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
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
                                    return val!.isEmpty || val.length < 4
                                        ? "Please provide Username"
                                        : null;
                                  },
                                  controller: userName,
                                  style: simpleTextFieldStyle(),
                                  decoration:
                                      textFieldInputDecoration('Username')),
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
                                  decoration:
                                      textFieldInputDecoration('Email')),
                              TextFormField(
                                  validator: (val) {
                                    return val!.length > 6
                                        ? null
                                        : "Please provide password greater than 6 characters";
                                  },
                                  obscureText: true,
                                  controller: password,
                                  style: simpleTextFieldStyle(),
                                  decoration:
                                      textFieldInputDecoration('Password')),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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
                          onTap: () {
                            signMEUP();
                          },
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
                            child:
                                Text('Sign Up', style: mediumTextFieldStyle()),
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
                            'Sign Up with Google',
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
                            Text("Already have an account?",
                                style: mediumTextFieldStyle()),
                            GestureDetector(
                              onTap: () {
                                widget
                                    .toggle(); //see above in signIn for explanation
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text("SignIn now",
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
