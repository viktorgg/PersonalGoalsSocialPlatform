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

    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await post(Uri.parse('$goalsURL/create'),
        headers: headers, body: json.encode(data));
    checkSessionExpired(response);
    Map responseMap = jsonDecode(response.body);
    Goal goal = Goal.fromMap(responseMap);

    return goal;
  }

  static Future<Goal> getGoal(int id) async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    var url = Uri.parse('$goalsURL/$id');
    Response response = await get(url, headers: headers);
    return Goal.fromMap(jsonDecode(response.body));
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
    return response;
  }
}
