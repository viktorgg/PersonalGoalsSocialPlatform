import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/models/user.dart';

class Goal {
  final int id;
  final String title;
  final String description;
  bool done;
  final int status;
  final User userOwner;
  final DateTime updatedAt;
  final List<GoalPost> progressPosts;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.done,
    required this.status,
    required this.userOwner,
    required this.updatedAt,
    required this.progressPosts,
  });

  factory Goal.fromMap(Map goalMap) {
    return Goal(
      id: goalMap['id'],
      title: goalMap['title'],
      description: goalMap['description'],
      done: goalMap['done'],
      status: goalMap['status'],
      updatedAt: DateTime.parse(goalMap['updatedAt']),
      progressPosts: goalMap['progressPosts'] == null
          ? []
          : GoalPost.fromMapList(goalMap['progressPosts']),
      userOwner: User.fromMap(goalMap['userOwner']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'done': done,
    };
  }

  void toggleStatus() {
    done = !done;
  }
}
