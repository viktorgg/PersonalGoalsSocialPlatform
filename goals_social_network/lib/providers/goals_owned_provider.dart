import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/models/goal.dart';
import 'package:goals_social_network/services/goal_services.dart';

class GoalsOwnedProvider extends ChangeNotifier {
  List<Goal> goalsOwned = [];

  void createGoal(String title, String description) async {
    Goal goal = await GoalServices.createGoal(title, description);
    goalsOwned.insert(0, goal);
    notifyListeners();
  }

  void updateGoal(Goal goal) {
    GoalServices.updateGoal(goal);
    notifyListeners();
  }

  void deleteGoal(Goal goal) {
    goalsOwned.remove(goal);
    GoalServices.deleteGoal(goal.id);
    notifyListeners();
  }
}
