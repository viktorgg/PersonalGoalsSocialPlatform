import 'dart:convert';
import 'dart:io';

import 'package:goals_social_network/models/goal.dart';
import 'package:goals_social_network/services/auth_user_services.dart';
import 'package:goals_social_network/services/globals.dart';
import 'package:http/http.dart';

import '../models/auth_user.dart';

class GoalServices {
  static Future<Goal> createGoal(String title, String description) async {
    AuthUser currentUser = await AuthUserServices.getUser();
    Map data = {
      "title": title,
      "description": description,
      "done": false,
      "userId": currentUser.userId,
    };

    print(data);

    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await post(Uri.parse('$goalsURL/create'),
        headers: headers, body: json.encode(data));
    checkSessionExpired(response);
    print(response.body);
    Map responseMap = jsonDecode(response.body);
    Goal goal = Goal.fromMap(responseMap);

    return goal;
  }

  static Future<List<Goal>> getGoals() async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    AuthUser currentUser = await AuthUserServices.getUser();
    int currentUserId = currentUser.userId;
    var url = Uri.parse('$userURL/$currentUserId/goalsowned');
    Response response = await get(url, headers: headers);
    print(url);
    List responseGoals = jsonDecode(response.body);
    List<Goal> goals = [];
    for (var element in responseGoals) {
      goals.add(Goal.fromMap(element));
    }

    goals.sort((a, b) {
      var date1 = a.updatedAt;
      var date2 = b.updatedAt;
      return date2.compareTo(date1);
    });
    return goals;
  }

  static Future<Response> updateGoal(Goal goal) async {
    var id = goal.id;
    var url = Uri.parse('$goalsURL/edit/$id');
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response =
        await put(url, headers: headers, body: json.encode(goal.toMap()));
    print(response.body);
    return response;
  }

  static Future<Response> deleteGoal(int id) async {
    var url = Uri.parse('$goalsURL/$id');
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await delete(url, headers: headers);
    print(response.body);
    return response;
  }
}
