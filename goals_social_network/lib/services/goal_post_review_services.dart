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

    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await post(Uri.parse('$postReviewsURL/create'),
        headers: headers, body: json.encode(data));
    Map responseMap = jsonDecode(response.body);
    GoalPostReview goalPostReview = GoalPostReview.fromMap(responseMap);

    return goalPostReview;
  }

  static Future<Response> updateGoalPostReview(GoalPostReview review) async {
    var id = review.id;
    var url = Uri.parse('$postReviewsURL/edit/$id');
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response =
        await put(url, headers: headers, body: json.encode(review.toMap()));
    return response;
  }

  static Future<List<GoalPostReview>> getGoalPostReviews(
      GoalPost goalPost) async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);

    int goalPostId = goalPost.id;
    var url = Uri.parse('$postReviewsURL/post/$goalPostId');

    Response response = await get(url, headers: headers);
    List responseGoalPosts = jsonDecode(response.body);

    List<GoalPostReview> goalPostReviews = [];
    for (var element in responseGoalPosts) {
      goalPostReviews.add(GoalPostReview.fromMap(element));
    }

    goalPostReviews.sort((a, b) {
      var date1 = a.updatedAt;
      var date2 = b.updatedAt;
      return date2.compareTo(date1);
    });
    return goalPostReviews;
  }

  static Future<Response> deleteGoalPostReview(int id) async {
    var url = Uri.parse('$postReviewsURL/$id');
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await delete(url, headers: headers);

    return response;
  }
}
