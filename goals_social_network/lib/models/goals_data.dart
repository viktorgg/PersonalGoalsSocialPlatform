import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/services/database_services.dart';
import 'package:goals_social_network/models/goal.dart';

class GoalsData extends ChangeNotifier {
  List<Goal> goals = [];

  void createGoal(String title, String description) async {
    Goal goal = await DatabaseServices.createGoal(title, description);
    goals.add(goal);
    notifyListeners();
  }

  void updateGoal(Goal goal) {
    goal.toggle();
    DatabaseServices.updateGoal(goal);
    notifyListeners();
  }

  void deleteGoal(Goal goal) {
    goals.remove(goal);
    DatabaseServices.deleteGoal(goal.id);
    notifyListeners();
  }
}