import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goals_social_network/services/auth_user_services.dart';
import 'package:http/http.dart';

import '../models/auth_user.dart';
import '../models/goal.dart';
import '../models/user.dart';
import 'globals.dart';

class UserServices {
  static Future<List<User>> getFollowingUsers() async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    AuthUser currentUser = await AuthUserServices.getUser();
    int currentUserId = currentUser.userId;
    var url = Uri.parse('$userURL/$currentUserId/rel');
    Response response = await get(url, headers: headers);
    checkSessionExpired(response);
    Map responseBody = jsonDecode(response.body);
    List elements = responseBody['following'];
    List<User> following = [];
    for (var element in elements) {
      following.add(User.fromMap(element));
    }

    return following;
  }

  static Future<List<Goal>> getFollowingUserGoals(int userId) async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    var url = Uri.parse('$userURL/$userId/goalsowned');
    Response response = await get(url, headers: headers);
    List responseGoals = jsonDecode(response.body);
    List<Goal> goals = [];
    for (var element in responseGoals) {
      print(Goal.fromMap(element));
      goals.add(Goal.fromMap(element));
    }

    return goals;
  }

  static Future<List<Goal>> getGoalsFollowed() async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    AuthUser currentUser = await AuthUserServices.getUser();
    int currentUserId = currentUser.userId;
    var url = Uri.parse('$userURL/$currentUserId/goalsfollowed');
    Response response = await get(url, headers: headers);
    List responseGoals = jsonDecode(response.body);
    List<Goal> goals = [];
    for (var element in responseGoals) {
      goals.add(Goal.fromMap(element));
    }

    return goals;
  }

  static Future<List<Goal>> getGoalsOwned() async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    AuthUser currentUser = await AuthUserServices.getUser();
    int currentUserId = currentUser.userId;
    var url = Uri.parse('$userURL/$currentUserId/goalsowned');
    Response response = await get(url, headers: headers);
    List responseGoals = jsonDecode(response.body);
    List<Goal> goals = [];
    for (var element in responseGoals) {
      goals.add(Goal.fromMap(element));
    }

    return goals;
  }

  static Future<List<User>> findUsersOnNameContaining(String name) async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    var url = Uri.parse('$userURL/findAllByName?name=$name');
    Response response = await get(url, headers: headers);
    List responseUsers = jsonDecode(response.body);
    List<User> foundUsers = [];
    for (var element in responseUsers) {
      foundUsers.add(User.fromMap(element));
    }

    return foundUsers;
  }

  static Future<void> followUser(int userId) async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    AuthUser currentUser = await AuthUserServices.getUser();
    int currentUserId = currentUser.userId;
    var url = Uri.parse('$userURL/$currentUserId/follow/$userId');
    await post(url, headers: headers);
  }
}
