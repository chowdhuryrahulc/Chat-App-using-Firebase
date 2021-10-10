import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextFieldStyle() {
  return const TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle mediumTextFieldStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}

AppBar appBarMain() {
  return AppBar(
      title: Image.asset(
    "assets/images/logo.png",
    height: 50,
  ));
}
