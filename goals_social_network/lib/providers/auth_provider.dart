import 'dart:convert';

import 'package:goals_social_network/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/services/user_services.dart';
import 'package:http/http.dart';

import '../models/user.dart';

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.notLoggedIn;
  final Status _registeredInStatus = Status.notRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;


  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final Map<String, dynamic> loginData = {
        'email': email,
        'password': password
    };

    _loggedInStatus = Status.authenticating;
    notifyListeners();

    var url = Uri.parse(signInURL);
    return await post(
      url,
      headers: header,
      body: json.encode(loginData),
    ).then(signInOnValue);
  }

  Future<Map<String, dynamic>> signInOnValue(Response response) async {
    Map<String, dynamic> result;
    Map responseMap = json.decode(response.body);
    if (response.statusCode == 200) {
      User authUser = User.fromMap(responseMap);

      UserServices.saveUser(authUser);

      _loggedInStatus = Status.loggedIn;
      notifyListeners();

      result = {
        'message': 'Successful',
        'data': authUser}
      ;
    } else {
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      result = {
        'message': responseMap['message'],
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> signUp(String firstName, String lastName, String email, String password) async {
    final Map<String, dynamic> registrationData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
    };

    var url = Uri.parse(signUpURL);
    return await post(url,
        headers: header,
        body: json.encode(registrationData),
    ).then(signUpOnValue);
  }

  Future<Map<String, dynamic>> signUpOnValue(Response response) async {
    Map<String, dynamic> result;
    Map responseMap = json.decode(response.body);

    if (response.statusCode == 200) {
      User authUser = User.fromMap(responseMap);

      UserServices.saveUser(authUser);
      result = {
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
      result = {
        'message': responseMap['message'],
      };
    }
    return result;
  }
}