import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/services/goal_services.dart';
import 'package:goals_social_network/models/goal.dart';

class GoalsProvider extends ChangeNotifier {
  final List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  set goals(goals) => _goals;

  void createGoal(String title, String description) async {
    Goal goal = await GoalServices.createGoal(title, description);
    _goals.add(goal);
    notifyListeners();
  }

  void updateGoal(Goal goal) {
    goal.toggle();
    GoalServices.updateGoal(goal);
    notifyListeners();
  }

  void deleteGoal(Goal goal) {
    _goals.remove(goal);
    GoalServices.deleteGoal(goal.id);
    notifyListeners();
  }
}