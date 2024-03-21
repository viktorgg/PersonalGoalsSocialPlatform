
import 'dart:convert';
import 'dart:io';

import 'package:goals_social_network/services/user_services.dart';
import 'package:http/http.dart';

import '../models/friend.dart';
import '../models/goal.dart';
import '../models/user.dart';
import 'globals.dart';

class FriendsServices {

  static Future<List<Friend>> getFriends() async {
    var token = await UserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    User currentUser = await UserServices.getUser();
    int currentUserId = currentUser.userId;
    var url =  Uri.parse('$userURL/$currentUserId/rel');
    Response response = await get(
        url,
        headers: headers
    );
    Map responseBody = jsonDecode(response.body);
    List elements = responseBody['following'];
    List<Friend> following = [];
    for (var element in elements) {
      following.add(Friend.fromMap(element));
    }

    return following;
  }

  static Future<List<Goal>> getFriendGoals(int friendId) async {
    var token = await UserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    var url =  Uri.parse('$userURL/$friendId/goals');
    Response response = await get(
        url,
        headers: headers
    );
    List responseGoals = jsonDecode(response.body);
    List<Goal> goals = [];
    for (var element in responseGoals) {
      goals.add(Goal.fromMap(element));
    }

    return goals;
  }
}