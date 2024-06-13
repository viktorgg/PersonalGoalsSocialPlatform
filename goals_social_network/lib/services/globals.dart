import 'dart:math';

import 'package:flutter/material.dart';

const String baseURL = "https://goals-app-springboot-e0223baa254e.herokuapp.com";
const Map<String, String> header = {"Content-Type": "application/json"};

const String goalsURL = '$baseURL/goals';
const String goalPostURL = '$baseURL/posts';
const String postReviewsURL = '$baseURL/reviews';
const String usersURL = '$baseURL/users';
const String invitesURL = '$baseURL/invites';
const String signUpURL = '$baseURL/signup';
const String signInURL = '$baseURL/signin';

const Color baseColor = Color.fromRGBO(50, 62, 72, 1.0);

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

String timeAgo(DateTime updatedAt) {
  int seconds = DateTime.now().difference(updatedAt).inSeconds;
  if (seconds < 60) {
    return '$seconds seconds ago';
  }
  if (seconds >= 60 && seconds < 3600) {
    return '${DateTime.now().difference(updatedAt).inMinutes} minutes ago';
  }
  if (seconds >= 3600 && seconds < 86400) {
    return '${DateTime.now().difference(updatedAt).inHours} hours ago';
  }
  if (seconds > 86400) {
    return '${DateTime.now().difference(updatedAt).inDays} days ago';
  }
  return '';
}

String generateRandomString(int len) {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}
