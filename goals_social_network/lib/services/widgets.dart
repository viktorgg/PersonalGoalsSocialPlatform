import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:goals_social_network/models/goal_post_review.dart';

import 'globals.dart';

MaterialButton longButtons(String title, Function() action,
    {Color color = baseColor, Color textColor = Colors.white}) {
  return MaterialButton(
    onPressed: action,
    textColor: textColor,
    color: color,
    height: 45,
    minWidth: 600,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

label(String title) => Text(title);

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: baseColor),
    hintText: hintText,
    contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

Flushbar successActionBar(String message) {
  return Flushbar(
    title: "Action",
    message: message,
    isDismissible: true,
    duration: const Duration(seconds: 3),
    backgroundColor: baseColor,
    messageColor: Colors.white,
    messageSize: 20,
  );
}

Flushbar invalidFormBar(String message) {
  return Flushbar(
    title: "Invalid Form",
    message: message,
    isDismissible: true,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.black,
    messageColor: Colors.white,
    messageSize: 20,
  );
}
