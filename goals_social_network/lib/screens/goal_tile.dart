import 'package:flutter/material.dart';

import '../models/goal.dart';
import '../providers/goals_provider.dart';

class GoalTile extends StatelessWidget {
  final Goal goal;
  final GoalsProvider goalsData;

  const GoalTile({Key? key, required this.goal, required this.goalsData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          activeColor: const Color.fromRGBO(50, 62, 72, 1.0),
          value: goal.done,
          onChanged: (checkbox) {
            goalsData.updateGoal(goal);
          },
        ),
        title: Text(
          goal.title,
          style: TextStyle(
            decoration:
            goal.done ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          goal.description,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            goalsData.deleteGoal(goal);
          },
        ),
      ),
    );
  }
}