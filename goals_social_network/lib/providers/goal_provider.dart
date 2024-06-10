import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/services/goal_services.dart';

import '../models/goal.dart';

class GoalProvider extends ChangeNotifier {
  Goal? goal;

  Future<void> setGoal(Goal goal) async {
    this.goal = await GoalServices.getGoal(goal.id);
    notifyListeners();
  }
}
