import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/models/goal_post_review.dart';

import '../services/goal_post_review_services.dart';

class PostReviewsProvider extends ChangeNotifier {
  List<GoalPostReview> reviews = [];

  void createReview(bool isApproved, String comment, GoalPost post) async {
    GoalPostReview review = await GoalPostReviewServices.createGoalPostReview(
        isApproved, comment, post);
    reviews.insert(0, review);
    notifyListeners();
  }

  void updateReview(GoalPostReview review) {
    GoalPostReviewServices.updateGoalPostReview(review);
    notifyListeners();
  }

  void deleteReview(GoalPostReview review) {
    reviews.remove(review);
    GoalPostReviewServices.deleteGoalPostReview(review.id);
    notifyListeners();
  }
}
