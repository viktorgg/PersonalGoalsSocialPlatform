import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/services/database_services.dart';
import 'package:goals_social_network/models/task.dart';

class TasksData extends ChangeNotifier {

  List<Task> tasks = [];

  void createTask(String title, String description) async {
    Task task = await DatabaseServices.createTask(title, description);
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(String title, String description) async {

  }

}