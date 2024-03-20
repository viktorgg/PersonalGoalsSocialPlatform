
import 'dart:convert';
import 'dart:io';

import 'package:goals_social_network/services/user_services.dart';
import 'package:http/http.dart';

import '../models/friend.dart';
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
    print(url);
    Map responseBody = jsonDecode(response.body);
    List elements = responseBody['following'];
    List<Friend> following = [];
    for (var element in elements) {
      following.add(Friend.fromMap(element));
    }

    return following;
  }
}