import 'dart:convert';
import 'dart:io';

import 'package:goals_social_network/models/goal_post.dart';
import 'package:http/http.dart';

import '../models/auth_user.dart';
import '../models/goal_post_review.dart';
import 'auth_user_services.dart';
import 'globals.dart';

class GoalPostReviewServices {
  static Future<GoalPostReview> createGoalPostReview(
      bool approved, String comment, GoalPost goalPost) async {
    AuthUser currentUser = await AuthUserServices.getUser();
    Map data = {
      "approved": approved,
      "comment": comment,
      "goalPostId": goalPost.id,
      "byUserId": currentUser.userId,
    };

    print(data);

    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await post(Uri.parse('$postReviewsURL/create'),
        headers: headers, body: json.encode(data));
    print(response.body);
    Map responseMap = jsonDecode(response.body);
    GoalPostReview goalPostReview = GoalPostReview.fromMap(responseMap);

    return goalPostReview;
  }

  static Future<List<GoalPostReview>> getGoalPostReviews(
      GoalPost goalPost) async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    int goalPostId = goalPost.id;
    var url = Uri.parse('$goalPostURL/post/$goalPostId');
    Response response = await get(url, headers: headers);
    List responseGoalPosts = jsonDecode(response.body);
    print(response.body);

    List<GoalPostReview> goalPostReviews = [];
    for (var element in responseGoalPosts) {
      goalPostReviews.add(GoalPostReview.fromMap(element));
    }

    return goalPostReviews;
  }
}
