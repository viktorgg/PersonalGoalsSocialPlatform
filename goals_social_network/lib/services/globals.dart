import 'package:flutter/material.dart';
import 'package:http/http.dart';

const String baseURL = "http://192.168.100.60:8080";
const Map<String, String> header = {"Content-Type": "application/json"};

const String goalsURL = '$baseURL/goals';
const String userURL = '$baseURL/user';
const String signUpURL = '$baseURL/signup';
const String signInURL = '$baseURL/signin';

const Color baseColor = Color.fromRGBO(50, 62, 72, 1.0);

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

checkSessionExpired(Response response) {
  if (response.statusCode == 403) {
    showDialog(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signin');
            },
          );
          return AlertDialog(
            title: const Text("Session expired"),
            content: const Text(
                "The session has expired. Click OK to sign in again."),
            actions: [
              okButton,
            ],
          );
        });
  }
}
