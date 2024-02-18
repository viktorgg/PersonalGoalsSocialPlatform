import 'package:flutter/material.dart';

import 'models/goal.dart';
import 'models/goals_data.dart';

class TaskTile extends StatelessWidget {
  final Goal task;
  final GoalsData tasksData;

  const TaskTile({Key? key, required this.task, required this.tasksData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          activeColor: Colors.green,
          value: task.done,
          onChanged: (checkbox) {
            tasksData.updateGoal(task);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
            task.done ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          task.description,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            tasksData.deleteGoal(task);
          },
        ),
      ),
    );
  }
}