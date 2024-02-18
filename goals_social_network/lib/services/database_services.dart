import 'package:goals_social_network/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:goals_social_network/models/goal.dart';

import 'dart:convert';

class DatabaseServices {

  static Future<Goal> createGoal(String title, String description) async {
    Map data = {
      "title": title,
      "description": description,
      "done": false
    };
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/create');

    http.Response response = await http.post(url, headers: headers, body: body);
    print(response.body);
    Map responseMap = jsonDecode(response.body);
    Goal goal = Goal.fromMap(responseMap);

    return goal;
  }

  static Future<List<Goal>> getGoals() async {
    var url = Uri.parse(baseURL);
    http.Response response = await http.get(url, headers: headers);
    print(response);
    List responseTasks = jsonDecode(response.body);
    List<Goal> goals = [];
    for (var element in responseTasks) {
      goals.add(Goal.fromMap(element));
    }
    return goals;
  }

  static Future<http.Response> updateGoal(Goal task) async {
    var id = task.id;
    var url = Uri.parse('$baseURL/update/$id');
    http.Response response = await http.put(url, headers: headers, body: json.encode(task.toMap()));
    print(response.body);
    return response;
  }

  static Future<http.Response> deleteGoal(int id) async {
    var url = Uri.parse('$baseURL/$id');
    http.Response response = await http.delete(url, headers: headers);
    print(response.body);
    return response;
  }
}

