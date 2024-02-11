import 'package:goals_social_network/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:goals_social_network/models/task.dart';

import 'dart:convert';

class DatabaseServices {

  static Future<Task> createTask(String title, String description) async {
    Map data = {
      "title": title,
      "description": description
    };
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/create');

    http.Response response = await http.post(url, headers: headers, body: body);
    print(response.body);
    Map responseMap = jsonDecode(response.body);
    Task task = Task.fromMap(responseMap);

    return task;
  }

  static Future<List<Task>> getTasks() async {
    var url = Uri.parse(baseURL);
    http.Response response = await http.get(url, headers: headers);
    print(response);
    List responseTasks = jsonDecode(response.body);
    List<Task> tasks = [];
    for (var element in responseTasks) {
      tasks.add(Task.fromMap(element));
    }
    return tasks;
  }
}

