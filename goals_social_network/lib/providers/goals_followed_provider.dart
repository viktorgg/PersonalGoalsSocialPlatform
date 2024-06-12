import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/models/goal.dart';
import 'package:goals_social_network/services/user_services.dart';

class GoalsFollowedProvider extends ChangeNotifier {
  List<Goal> goalsFollowed = [];

  void followGoal(Goal goal) {
    goalsFollowed.insert(0, goal);
    UserServices.followGoal(goal.id);
    notifyListeners();
  }

  void unfollowGoal(Goal goal) {
    goalsFollowed.remove(goal);
    UserServices.unfollowGoal(goal.id);
    notifyListeners();
  }
}
