import 'package:flutter/cupertino.dart';
import 'package:goals_social_network/services/database_services.dart';
import 'package:goals_social_network/models/task.dart';

class TasksData extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(String title, String description, bool done) async {
    Task task = await DatabaseServices.createTask(title, description, done);
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggle();
    DatabaseServices.updateTask(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    DatabaseServices.deleteTask(task.id);
    notifyListeners();
  }
}