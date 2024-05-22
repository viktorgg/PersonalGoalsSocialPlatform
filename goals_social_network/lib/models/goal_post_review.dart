import 'package:goals_social_network/models/user.dart';

class GoalPostReview {
  final int id;
  String comment;
  bool approved;
  final User userOwner;
  final DateTime updatedAt;

  GoalPostReview({
    required this.id,
    required this.comment,
    required this.approved,
    required this.userOwner,
    required this.updatedAt,
  });

  set setComment(String comment) {
    this.comment = comment;
  }

  set setApproved(bool approved) {
    this.approved = approved;
  }

  factory GoalPostReview.fromMap(Map goalPostReviewMap) {
    return GoalPostReview(
      id: goalPostReviewMap['id'],
      comment: goalPostReviewMap['comment'],
      approved: goalPostReviewMap['approved'],
      userOwner: User.fromMap(goalPostReviewMap['userOwner']),
      updatedAt: DateTime.parse(goalPostReviewMap['updatedAt']),
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
      'userOwner': userOwner.toMap(),
    };
  }
}
