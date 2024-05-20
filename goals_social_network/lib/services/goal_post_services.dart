import 'dart:convert';
import 'dart:io';

import 'package:goals_social_network/models/goal_post.dart';
import 'package:http/http.dart';

import '../models/goal.dart';
import 'auth_user_services.dart';
import 'globals.dart';

class GoalPostServices {
  static Future<GoalPost> createGoalPost(String description, Goal goal) async {
    Map data = {
      "description": description,
      "goalId": goal.id,
    };

    print(data);

    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await post(Uri.parse('$goalPostURL/create'),
        headers: headers, body: json.encode(data));
    print(response.body);
    Map responseMap = jsonDecode(response.body);
    GoalPost goalPost = GoalPost.fromMap(responseMap);

    return goalPost;
  }

  static Future<List<GoalPost>> getGoalPosts(Goal goal) async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    int goalId = goal.id;
    var url = Uri.parse('$goalPostURL/goal/$goalId');
    Response response = await get(url, headers: headers);
    List responseGoalPosts = jsonDecode(response.body);

    List<GoalPost> goalPosts = [];
    for (var element in responseGoalPosts) {
      goalPosts.add(GoalPost.fromMap(element));
    }

    goalPosts.sort((a, b) {
      var date1 = a.updatedAt;
      var date2 = b.updatedAt;
      return date2.compareTo(date1);
    });
    return goalPosts;
  }

  static Future<Response> deleteGoalPost(int id) async {
    var url = Uri.parse('$goalPostURL/$id');
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
