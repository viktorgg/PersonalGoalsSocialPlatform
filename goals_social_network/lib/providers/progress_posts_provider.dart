import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/models/goal.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/services/goal_post_services.dart';

class ProgressPostsProvider extends ChangeNotifier {
  List<GoalPost> posts = [];

  void createPost(String description, Goal goal) async {
    GoalPost post = await GoalPostServices.createGoalPost(description, goal);
    posts.insert(0, post);
    notifyListeners();
  }

// void deleteGoal(Goal goal) {
//   goalsOwned.remove(goal);
//   GoalServices.deleteGoal(goal.id);
//   notifyListeners();
// }
}
