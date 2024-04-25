import 'goal_post_review.dart';

class GoalPost {
  final int id;
  final String description;
  final List<GoalPostReview> reviews;

  GoalPost({
    required this.id,
    required this.description,
    required this.reviews,
  });

  factory GoalPost.fromMap(Map goalPostMap) {
    return GoalPost(
      id: goalPostMap['id'],
      description: goalPostMap['description'],
      reviews: GoalPostReview.fromMapList(goalPostMap['postReviews']),
    );
  }

  static List<GoalPost> fromMapList(List goalPostMaps) {
    List<GoalPost> goalPosts = [];
    for (var element in goalPostMaps) {
      goalPosts.add(GoalPost.fromMap(element));
    }
    return goalPosts;
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
    };
  }
}
