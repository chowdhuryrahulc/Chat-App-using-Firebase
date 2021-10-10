// ignore_for_file: unused_local_variable
//! _auth = FirebaseAuth.instance
//! _auth.signInWithEmailAndPassword(email: email, password: password)
//! _auth.createUserWithEmailAndPassword(email: email, password: password)
//! _auth.sendPasswordResetEmail(email: email)
//! _auth.signOut()

import 'package:chatapp/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authmethords {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserXYZ? _userFromFirebaseUser(User? user) {
    return user != null ? UserXYZ(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      //AuthResult => UserCredential, FirebaseUser => User
      //these are from Auth package
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? fUser = result.user;
      return _userFromFirebaseUser(fUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      //AuthResult => UserCredential, FirebaseUser => User
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? fUser = result.user;
      return _userFromFirebaseUser(fUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
