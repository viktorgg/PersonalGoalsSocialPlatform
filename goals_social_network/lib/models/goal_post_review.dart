import 'package:goals_social_network/models/user.dart';

class GoalPostReview {
  final int id;
  final String comment;
  final bool approved;
  final User userOwner;

  GoalPostReview({
    required this.id,
    required this.comment,
    required this.approved,
    required this.userOwner,
  });

  factory GoalPostReview.fromMap(Map goalPostReviewMap) {
    return GoalPostReview(
      id: goalPostReviewMap['id'],
      comment: goalPostReviewMap['comment'],
      approved: goalPostReviewMap['approved'],
      userOwner: User.fromMap(goalPostReviewMap['userOwner']),
    );
  }

  static List<GoalPostReview> fromMapList(List goalPostReviewMaps) {
    List<GoalPostReview> goalPostsReviews = [];
    for (var element in goalPostReviewMaps) {
      goalPostsReviews.add(GoalPostReview.fromMap(element));
    }
    return goalPostsReviews;
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'approved': approved,
    };
  }
}
