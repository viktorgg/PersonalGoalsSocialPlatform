import 'dart:io';

import 'package:goals_social_network/services/globals.dart';
import 'package:goals_social_network/services/user_services.dart';
import 'package:http/http.dart';
import 'package:goals_social_network/models/goal.dart';

import 'dart:convert';

class GoalServices {

  static Future<Goal> createGoal(String title, String description) async {
    Map data = {
      "title": title,
      "description": description,
      "done": false
    };

    var token = await UserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await post(
        Uri.parse('$goalsURL/create'),
        headers: headers,
        body: json.encode(data)
    );
    print(response.body);
    Map responseMap = jsonDecode(response.body);
    Goal goal = Goal.fromMap(responseMap);

    return goal;
  }

  static Future<List<Goal>> getGoals() async {
    var url = Uri.parse(goalsURL);
    var token = await UserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    print(headers);
    Response response = await get(
        url,
        headers: headers
    );
    print(response);
    List responseTasks = jsonDecode(response.body);
    List<Goal> goals = [];
    for (var element in responseTasks) {
      goals.add(Goal.fromMap(element));
    }
    return goals;
  }

  static Future<Response> updateGoal(Goal task) async {
    var id = task.id;
    var url = Uri.parse('$goalsURL/update/$id');
    var token = await UserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await put(
        url,
        headers: headers,
        body: json.encode(task.toMap())
    );
    print(response.body);
    return response;
  }

  static Future<Response> deleteGoal(int id) async {
    var url = Uri.parse('$goalsURL/$id');
    var token = await UserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await delete(
        url,
        headers: headers
    );
    print(response.body);
    return response;
  }
}
